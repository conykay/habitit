import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:habitit/core/db/hive_core.dart';
import 'package:habitit/data/notifications/models/notification_item.dart';
import 'package:hive/hive.dart';

abstract class NotificationHiveService extends HiveCore {
  Stream<List<NotificationItem>> notificationListener();

  Future<void> addNotification(RemoteMessage message);

  List<NotificationItem> get notifications;

  Future<void> deleteNotifications();
}

class NotificationHiveServiceImpl extends NotificationHiveService {
  late final Box<NotificationItem> _notificationBox;

  NotificationHiveServiceImpl._(this._notificationBox);

  static Future<NotificationHiveServiceImpl> getInstance() async {
    final user = FirebaseAuth.instance.currentUser;
    final boxName = 'notifications_${user?.uid}';
    Box<NotificationItem> notificationBox;
    if (Hive.isBoxOpen(boxName)) {
      notificationBox = Hive.box<NotificationItem>(boxName);
    } else {
      notificationBox = await Hive.openBox<NotificationItem>(boxName);
    }
    return NotificationHiveServiceImpl._(notificationBox);
  }

  @override
  List<NotificationItem> get notifications =>
      _notificationBox.isOpen ? _notificationBox.values.toList() : [];

  @override
  Stream<List<NotificationItem>> notificationListener() {
    if (!_notificationBox.isOpen) {
      print('Notification Box was not open');
    }
    return _notificationBox
        .watch()
        .map((event) => _notificationBox.values.toList());
  }

  @override
  Future<void> addNotification(RemoteMessage message) async {
    try {
      print('A notification was received: $message');
      if (message.notification != null && message.notification!.body != null) {
        NotificationItem notificationItem = NotificationItem(
          data: message.data,
          sentAt: message.sentTime,
          title: message.notification!.title,
          body: message.notification!.body,
          category: message.category,
        );
        await _notificationBox.add(notificationItem);
      }
      print('Notification added successfully');
    } catch (e) {
      print('Notification Service Error: $e');
    }
  }

  @override
  Future<void> close() async {
    if (_notificationBox.isOpen) {
      await _notificationBox.close();
    }
  }

  @override
  Future<void> deleteNotifications() async {
    if (_notificationBox.isOpen) {
      await _notificationBox.clear();
    }
  }
}
