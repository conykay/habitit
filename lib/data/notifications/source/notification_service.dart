import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:habitit/env/env.dart';
import 'package:habitit/firebase_options.dart';
import 'package:http/http.dart' as http;

import '../../../service_locator.dart';
import 'notifications_hive_service.dart';

abstract class NotificationService {
  Future<void> grantAppPermission();

  Future<void> init();

  StreamSubscription<RemoteMessage> get onMessage;

  StreamSubscription<RemoteMessage> get onMessageOpenedApp;

  Future<String?> getToken();

  Future<void> sendNewBadgeNotification(
      {required String uid,
      required String badgeName,
      required String badgeDescription});

  void listenToTokenRefresh(void Function(String) onNewToken);

  void dispose();
}

class NotificationServiceImpl extends NotificationService {
  final FirebaseMessaging _messagingInstance = FirebaseMessaging.instance;
  static final _vapidKey = Env.vapidKey;
  static final _sendBadgeNotificationUrl =
      Uri.https('habititservice.onrender.com', 'api/sendBadgeNotification');

  //Foreground messages subscription
  StreamSubscription<RemoteMessage>? _messageSubscription;

//Background messages subscription redirect user to screen if app is in background
  StreamSubscription<RemoteMessage>? _openedAppSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;

  // initialize firebase messaging

  @override
  Future<void> init() async {
    _messageSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Remote message received: ${message.notification}');
      var hiveService = await sl.getAsync<NotificationHiveService>();
      await hiveService.addNotification(message);
    });
    _openedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

// permissions
  @override
  Future<void> grantAppPermission() async {
    NotificationSettings notificationSettings =
        await _messagingInstance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      provisional: false,
      sound: true,
    );

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
        print('user did not grant permissions');
      }
    }
  }

  // get token

  @override
  Future<String?> getToken() async {
    String? token;
    if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
      token = await _messagingInstance.getToken(vapidKey: _vapidKey);
      if (kDebugMode) {
        print(token);
      }
    } else {
      token = await _messagingInstance.getToken();
    }
    print('this is the token:: $token');
    return token;
  }

  @override
  void listenToTokenRefresh(void Function(String) onNewToken) {
    _tokenRefreshSubscription =
        _messagingInstance.onTokenRefresh.listen((newToken) {
      onNewToken(newToken);
    });
  }

// send notification request
  @override
  Future<void> sendNewBadgeNotification(
      {required String uid,
      required String badgeName,
      required String badgeDescription}) async {
    try {
      var res = await http.post(
        _sendBadgeNotificationUrl,
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

  @override
  StreamSubscription<RemoteMessage> get onMessage => _messageSubscription!;

  @override
  StreamSubscription<RemoteMessage> get onMessageOpenedApp =>
      _openedAppSubscription!;

  void dispose() {
    _messageSubscription?.cancel();
    _openedAppSubscription?.cancel();
    _tokenRefreshSubscription?.cancel();
    if (kDebugMode) {
      print('NotificationService disposed and subscriptions cancelled.');
    }
  }
}
