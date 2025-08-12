import 'package:dartz/dartz.dart';

abstract class QuotesRepository {
  Future<Either> getQuotes();

  Future<Either> getQuote();
}
