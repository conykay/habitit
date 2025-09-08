import 'package:habitit/domain/quotes/entities/quotes_entity.dart';
import 'package:hive/hive.dart';

abstract class QuotesHiveService {
  Future<void> addQuotes({required List<QuotesEntity> quotes});

  Future<List<QuotesEntity>> getAllQuotes();
}

class QuotesHiveServiceImpl extends QuotesHiveService {
  @override
  Future<List<QuotesEntity>> getAllQuotes() async {
    final hiveBox = await Hive.openBox<QuotesEntity>('Quotes');
    try {
      return hiveBox.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addQuotes({required List<QuotesEntity> quotes}) async {
    final hiveBox = await Hive.openBox<QuotesEntity>('Quotes');

    try {
      for (var quote in quotes) {
        await hiveBox.put(quote.quote, quote);
      }
    } catch (e) {
      rethrow;
    }
  }
}
