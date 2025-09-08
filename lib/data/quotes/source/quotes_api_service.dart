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
      print('The API was made again');
      var response =
          await http.get(Uri.parse('https://zenquotes.io/api/quotes'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data.map((e) => QuotesModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load quotes');
      }
    } catch (e) {
      rethrow;
    }
  }
}
