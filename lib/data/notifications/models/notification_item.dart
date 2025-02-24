// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  String? category;
  Map<String, dynamic> data;
  DateTime? sentAt;
  String? title;
  String? body;
  NotificationItem({
    this.category,
    required this.data,
    this.sentAt,
    this.title,
    this.body,
  });

  @override
  List<Object?> get props => [
        category,
        data,
        sentAt,
        title,
        body,
      ];
}
