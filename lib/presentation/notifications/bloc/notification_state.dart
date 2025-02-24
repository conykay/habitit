// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:habitit/data/notifications/models/notification_item.dart';

class NotificationState {
  final List<NotificationItem> notifications;
  NotificationState({
    this.notifications = const [],
  });
}
