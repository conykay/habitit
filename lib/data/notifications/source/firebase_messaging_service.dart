import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final FirebaseMessaging messagingInstance = FirebaseMessaging.instance;

// permissions
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

  // get token

  Future<String?> getToken() async {
    final token = await messagingInstance.getToken();
    return token;
  }

  void listenToTokenRefresh(void Function(String) onNewToken) {
    messagingInstance.onTokenRefresh.listen((newToken) {
      onNewToken(newToken);
    });
  }
// send notification request

  static void sendNewBadgeNotification(
      {required String uid,
      required String badgeName,
      required String badgeDescription}) async {
    var url = Uri.http('localhost:3000', 'sendBadgeNotification');
    var res = await http.post(url, body: {
      'uid': uid,
      'badgeName': badgeName,
      'badgeDescription': badgeDescription
    });
    if (kDebugMode) {
      print('Response body: ${res.body}');
    }
  }
}
