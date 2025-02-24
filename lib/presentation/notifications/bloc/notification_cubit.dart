import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/data/notifications/models/notification_item.dart';
import 'package:habitit/presentation/notifications/bloc/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  late final StreamSubscription<RemoteMessage> _messageSubscription;
  late final StreamSubscription<RemoteMessage> _openedAppSubscription;

  NotificationCubit() : super(NotificationState()) {
    _messageSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;

      if (notification != null && notification.body != null) {
        addNotification(
            notification: NotificationItem(
                data: message.data,
                sentAt: message.sentTime,
                title: notification.title,
                body: notification.body,
                category: message.category));
      }
    });
    _openedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null && notification.body != null) {
        addNotification(
            notification: NotificationItem(
                data: message.data,
                sentAt: message.sentTime,
                title: notification.title,
                body: notification.body,
                category: message.category));
      }
    });
  }

  Future<void> onBackgroundHandler(RemoteMessage? message) async {
    final notification = message!.notification;
    if (notification != null && notification.body != null) {
      addNotification(
          notification: NotificationItem(
              data: message.data,
              sentAt: message.sentTime,
              title: notification.title,
              body: notification.body,
              category: message.category));
    }
  }

  void addNotification({required NotificationItem notification}) async {
    final updateNotifications = List<NotificationItem>.from(state.notifications)
      ..add(notification);
    emit(NotificationState(notifications: updateNotifications));
  }

  void clearNotifications() {
    emit(NotificationState(notifications: []));
  }

  @override
  Future<void> close() {
    _messageSubscription.cancel();
    _openedAppSubscription.cancel();
    return super.close();
  }
}
