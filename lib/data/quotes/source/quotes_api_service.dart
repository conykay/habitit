import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/quotes_model.dart';

const String quotesUrl = 'https://zenquotes.io/api/quotes';

abstract class QuotesApiService {
  Future<List<QuotesModel>> getAllQuotes();
}

class QuotesApiServiceImpl extends QuotesApiService {
  @override
  Future<List<QuotesModel>> getAllQuotes() async {
    try {
      var response = await http.get(Uri.parse(quotesUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        List<QuotesModel> quotes = data
            .map<QuotesModel>(
                (e) => QuotesModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return quotes;
      } else {
        throw Exception(
            'Server error ${response.statusCode} Failed to load quotes');
      }
    } catch (e) {
      throw Exception('Failed to load quotes error: $e');
    }
  }
}
