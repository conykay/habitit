import 'package:dartz/dartz.dart';

abstract class QuotesRepository {
  Future<Either> getAllQuotes();

  Future<Either> getQuote();
}
