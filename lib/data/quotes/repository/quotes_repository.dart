import 'package:dartz/dartz.dart';
import 'package:habitit/data/quotes/models/quotes_model.dart';
import 'package:habitit/data/quotes/source/quotes_api_service.dart';
import 'package:habitit/domain/quotes/repository/quotes.dart';

import '../../../service_locator.dart';

class QuotesRepositoryImp extends QuotesRepository {
  @override
  Future<Either> getQuotes() async {
    try {
      var quotes = await sl.get<QuotesApiService>().getQuotes();
      return Right(quotes.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getQuote() async {
    try {
      var quote = await sl.get<QuotesApiService>().getQuote();
      return Right(quote.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }
}

//todo: Save quotes to local memory and only make API call if the quotes are saved or are more than a week old.
