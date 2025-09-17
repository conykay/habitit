import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/data/notifications/source/notifications_hive_service.dart';
import 'package:habitit/presentation/notifications/bloc/notification_state.dart';

import '../../../data/notifications/models/notification_item.dart';
import '../../../service_locator.dart';

class NotificationCubit extends Cubit<NotificationState> {
  StreamSubscription? _notifications;

  NotificationCubit() : super(NotificationState()) {
    _notificationSubscription();
  }

  void _notificationSubscription() async {
    _loadAvailableNotifications();
    await sl.getAsync<NotificationHiveService>().then((notificationService) {
      _notifications =
          notificationService.notificationListener().listen((event) {
        emit(state.copyWith(notifications: event));
      }, onError: (e) => emit(state.copyWith(error: e.toString())));
    });
  }

  void _loadAvailableNotifications() async {
    List<NotificationItem> notifications = await sl
        .getAsync<NotificationHiveService>()
        .then((value) => value.notifications);
    emit(state.copyWith(notifications: notifications));
  }

  void markAllAsRead() async {
    List<NotificationItem> notifications = await sl
        .getAsync<NotificationHiveService>()
        .then((value) => value.notifications);
    for (var notification in notifications) {
      notification.isRead = true;
    }
    emit(state.copyWith(notifications: notifications));
  }

  void clearNotifications() async {
    await sl
        .getAsync<NotificationHiveService>()
        .then((value) => value.deleteNotifications());
  }

  @override
  Future<void> close() {
    _notifications?.cancel();
    return super.close();
  }
}
