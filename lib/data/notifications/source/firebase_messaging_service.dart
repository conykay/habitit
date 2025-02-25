import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:habitit/firebase_options.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final FirebaseMessaging messagingInstance = FirebaseMessaging.instance;
  static const vapidKey =
      "BGUpq07QOgLng69S4tb38gruFJMIfz522Py0GcIEe4JYyWUeOrtGd2pbr28gg3gNQNmW0fnkcPLQd7fAItgw6AE";
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
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('user did not grant permisions');
      }
    }
  }

  // get token

  Future<String?> getToken() async {
    String? token;
    if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
      token = await messagingInstance.getToken(vapidKey: vapidKey);
      if (kDebugMode) {
        print(token);
      }
    } else {
      token = await messagingInstance.getToken();
    }
    return token;
  }

  void listenToTokenRefresh(void Function(String) onNewToken) {
    messagingInstance.onTokenRefresh.listen((newToken) {
      onNewToken(newToken);
    });
  }
// send notification request

  static Future<void> sendNewBadgeNotification(
      {required String uid,
      required String badgeName,
      required String badgeDescription}) async {
    try {
      var url =
          Uri.https('habititservice.onrender.com', 'api/sendBadgeNotification');

      var res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "uid": uid,
          "badgeName": badgeName,
          "badgeDescription": badgeDescription
        }),
      );
      if (kDebugMode) {
        print('Response body: ${res.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
