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

  // Singleton instance
  static Future<NotificationHiveServiceImpl> getInstance(
      {required FirebaseAuth auth}) async {
    //get the current user
    final User? user = auth.currentUser;
    //check if the box is already open and if not, open it
    final boxName = 'notifications_${user?.uid}';
    Box<NotificationItem> notificationBox;
    if (Hive.isBoxOpen(boxName)) {
      notificationBox = Hive.box<NotificationItem>(boxName);
    } else {
      notificationBox = await Hive.openBox<NotificationItem>(boxName);
    }
    //return the instance
    return NotificationHiveServiceImpl._(notificationBox);
  }

  //get the notifications from the box and return them as a list of NotificationItem objects
  @override
  List<NotificationItem> get notifications =>
      _notificationBox.isOpen ? _notificationBox.values.toList() : [];

  //listen to the box and return a stream of lists of NotificationItem objects
  @override
  Stream<List<NotificationItem>> notificationListener() {
    //check if the box is open and if not, open it
    if (!_notificationBox.isOpen) {
      throw Exception('Notification box is not open');
    }
    //return a stream of lists of NotificationItem objects
    return _notificationBox
        .watch()
        .map((event) => _notificationBox.values.toList());
  }

  //add a notification to the box and print a message if successful
  @override
  Future<void> addNotification(RemoteMessage message) async {
    try {
      //check that notification is not null and body is not null
      if (message.notification != null && message.notification!.body != null) {
        //create a new NotificationItem object and add it to the box
        NotificationItem notificationItem = NotificationItem(
          data: message.data,
          sentAt: message.sentTime,
          title: message.notification!.title,
          body: message.notification!.body,
          category: message.category,
        );
        //add the notification to the box
        await _notificationBox.add(notificationItem);
      }
    } catch (e) {
      throw Exception('Failed to add notification to box : $e');
    }
  }

  //close the box if it is open
  @override
  Future<void> close() async {
    if (_notificationBox.isOpen) {
      await _notificationBox.close();
    }
  }

  //delete all notifications from the box
  @override
  Future<void> deleteNotifications() async {
    if (_notificationBox.isOpen) {
      await _notificationBox.clear();
    }
  }
}
