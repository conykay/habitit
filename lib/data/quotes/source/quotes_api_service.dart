import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../models/quotes_model.dart';

abstract class QuotesApiService {
  Future<List<QuotesModel>> getQuotes();

  Future<QuotesModel> getQuote();
}

class QuotesApiServiceImpl extends QuotesApiService {
  List<QuotesModel> quotes = [];

  @override
  Future<List<QuotesModel>> getQuotes() async {
    try {
      if (quotes.isEmpty) {
        print('The API was made again');
        var response =
            await http.get(Uri.parse('https://zenquotes.io/api/quotes'));
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          data.map<QuotesModel>((e) => QuotesModel.fromJson(e)).toList();
          quotes =
              data.map<QuotesModel>((e) => QuotesModel.fromJson(e)).toList();
        } else {
          throw Exception('Failed to load quotes');
        }
      }
      return quotes;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QuotesModel> getQuote() async {
    try {
      if (quotes.isEmpty) {
        await getQuotes();
      }
      Random rand = Random();
      var random = rand.nextInt(quotes.length);
      return quotes[random];
    } catch (e) {
      throw Exception('Failed to retrieve quote');
    }
  }
}
