class QuotesModel {
  final String quote;
  final String author;

  QuotesModel({
    required this.quote,
    required this.author,
  });

  Map<String, String> toMap() {
    return {
      'q': quote,
      'a': author,
    };
  }

  factory QuotesModel.fromJson(Map<String, String> json) {
    return QuotesModel(
      quote: json['q']!,
      author: json['a']!,
    );
  }
}
