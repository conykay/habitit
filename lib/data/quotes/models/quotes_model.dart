import '../../../domain/quotes/entities/quotes_entity.dart';

class QuotesModel {
  final String quote;
  final String author;

  QuotesModel({
    required this.quote,
    required this.author,
  });

  Map<String, dynamic> toMap() {
    return {
      'q': quote,
      'a': author,
    };
  }

  factory QuotesModel.fromJson(Map<String, dynamic> json) {
    return QuotesModel(
      quote: json['q']!,
      author: json['a']!,
    );
  }
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
