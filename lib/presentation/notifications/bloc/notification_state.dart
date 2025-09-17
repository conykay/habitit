// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:habitit/data/notifications/models/notification_item.dart';

class NotificationState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<NotificationItem> notifications;
  const NotificationState(
      {this.notifications = const [], this.isLoading = false, this.error});

  @override
  List<Object?> get props => [notifications, isLoading, error];

  NotificationState copyWith({
    List<NotificationItem>? notifications,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
