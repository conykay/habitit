import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/quotes_model.dart';

abstract class QuotesApiService {
  Future<List<QuotesModel>> getAllQuotes();
}

class QuotesApiServiceImpl extends QuotesApiService {
  @override
  Future<List<QuotesModel>> getAllQuotes() async {
    try {
      var response =
          await http.get(Uri.parse('https://zenquotes.io/api/quotes'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<QuotesModel> quotes =
            data.map((e) => QuotesModel.fromJson(e)).toList();
        return quotes;
      } else {
        throw Exception('Failed to load quotes');
      }
    } catch (e) {
      rethrow;
    }
  }
}
