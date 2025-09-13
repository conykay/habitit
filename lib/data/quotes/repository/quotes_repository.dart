import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:habitit/data/quotes/models/quotes_model.dart';
import 'package:habitit/data/quotes/source/quotes_api_service.dart';
import 'package:habitit/data/quotes/source/quotes_hive_service.dart';
import 'package:habitit/domain/quotes/entities/quotes_entity.dart';
import 'package:habitit/domain/quotes/repository/quotes.dart';

import '../../../service_locator.dart';

class QuotesRepositoryImp extends QuotesRepository {
  @override
  Future<Either> getAllQuotes() async {
    final time = DateTime.now();
    //time a week ago
    final oneWeek = DateTime.now().subtract(const Duration(days: 7));
    try {
      //get from local db
      List<QuotesEntity> quotes =
          await sl.get<QuotesHiveService>().getAllQuotes();
      //if local empty or older than a week, get from API and sync to local
      if (quotes.isEmpty || quotes.last.receivedAt!.isBefore(oneWeek)) {
        //get from API
        List<QuotesModel> apiQuotes =
            await sl.get<QuotesApiService>().getAllQuotes();
        //sync to local
        await sl.get<QuotesHiveService>().addQuotes(
            quotes: apiQuotes
                .map((e) => e.toEntity().copyWith(receivedAt: time))
                .toList());
        //get from local
        quotes = await sl.get<QuotesHiveService>().getAllQuotes();
      }

      return Right(quotes);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getQuote() async {
    try {
      //get quotes from service
      Either quotes = await getAllQuotes();
      Random rand = Random();
      return quotes.fold(
        (l) => throw Exception('Failed to retrieve quotes'),
        (quotes) {
          // return random quote from list
          var random = rand.nextInt(quotes.length);
          return Right(quotes[random]);
        },
      );
    } catch (e) {
      return Left('Failed to retrieve quote');
    }
  }
}
