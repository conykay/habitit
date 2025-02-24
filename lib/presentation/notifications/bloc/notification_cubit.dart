import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/presentation/notifications/bloc/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  late final StreamSubscription<RemoteMessage> _messageSubscription;
  late final StreamSubscription<RemoteMessage> _openedAppSubscription;

  NotificationCubit() : super(NotificationState()) {
    _messageSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null && notification.body != null) {
        addNotification(notification: notification.body!);
      }
    });
    _openedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null && notification.body != null) {
        addNotification(notification: "Opened: ${notification.body!}");
      }
    });
  }

  Future<void> onBackgroundHandler(RemoteMessage? message) async {
    final notification = message!.notification;
    if (notification != null && notification.body != null) {
      addNotification(notification: "Opened: ${notification.body!}");
    }
  }

  void addNotification({required String notification}) async {
    final updateNotifications = List<String>.from(state.notifications)
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
