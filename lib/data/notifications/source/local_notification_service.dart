import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final localNotification = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

/*     void onDidReceiveNotification(
        int? id, String? title, String? body, String? payload) async {
      print('notification received');
    } */

    final DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );
    final InitializationSettings settings = InitializationSettings(
        android: initializationSettings, iOS: darwinInitializationSettings);

    await localNotification.initialize(settings);
  }
}
