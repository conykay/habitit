import 'package:habitit/domain/quotes/entities/quotes_entity.dart';
import 'package:hive/hive.dart';

abstract class QuotesHiveService {
  Future<void> addQuotes({required List<QuotesEntity> quotes});

  Future<List<QuotesEntity>> getAllQuotes();
}

class QuotesHiveServiceImpl extends QuotesHiveService {
  final String boxName = 'Quotes';

  //Open box and return it
  Future<Box<QuotesEntity>> _openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<QuotesEntity>(boxName);
    } else {
      return Hive.box<QuotesEntity>(boxName);
    }
  }

  //get all quotes from hive
  @override
  Future<List<QuotesEntity>> getAllQuotes() async {
    final hiveBox = await _openBox();
    try {
      return hiveBox.values.toList();
    } catch (e) {
      throw Exception('Failed to load quotes from Hive: $e');
    }
  }

  @override
  Future<void> addQuotes({required List<QuotesEntity> quotes}) async {
    final hiveBox = await _openBox();
    try {
      for (var quote in quotes) {
        await hiveBox.put(quote.quote, quote);
      }
    } catch (e) {
      throw Exception('Failed to add quotes to Hive: $e');
    }
  }
}
