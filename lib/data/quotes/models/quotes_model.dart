import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/quotes/entities/quotes_entity.dart';

part 'quotes_model.freezed.dart';
part 'quotes_model.g.dart';

@freezed
class QuotesModel with _$QuotesModel {
  factory QuotesModel({
    required String quote,
    required String author,
  }) = _QuotesModel;

  factory QuotesModel.fromJson(Map<String, Object?> json) =>
      _$QuotesModelFromJson(json);
}

extension QuotesModelX on QuotesModel {
  QuotesEntity toEntity() => QuotesEntity(
        author: author,
        quote: quote,
      );
}

extension QuotesEntityX on QuotesEntity {
  QuotesModel toModel() => QuotesModel(
        author: author,
        quote: quote,
      );
}
