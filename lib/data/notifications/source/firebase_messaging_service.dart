import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging messagingInstance = FirebaseMessaging.instance;

  Future<String?> getToken() async {
    final token = await messagingInstance.getToken();
    return token;
  }

  void listenToTokenRefresh(void Function(String) onNewToken) {
    messagingInstance.onTokenRefresh.listen((newToken) {
      onNewToken(newToken);
    });
  }

  Future<void> grantAppPermission() async {
    NotificationSettings notificationSettings =
        await messagingInstance.requestPermission(
            alert: true,
            announcement: true,
            badge: true,
            provisional: false,
            sound: true);

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print('user granted permission');
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user granted provisional permission');
    } else {
      print('user did not grant permisions');
    }
  }
}
