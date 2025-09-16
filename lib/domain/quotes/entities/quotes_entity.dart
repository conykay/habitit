import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'quotes_entity.freezed.dart';
part 'quotes_entity.g.dart';

@freezed
class QuotesEntity with _$QuotesEntity {
  QuotesEntity._();

  @HiveType(typeId: 3)
  factory QuotesEntity({
    @HiveField(0) required String author,
    @HiveField(1) required String quote,
    @HiveField(2) DateTime? receivedAt,
  }) = _QuotesEntity;
}
