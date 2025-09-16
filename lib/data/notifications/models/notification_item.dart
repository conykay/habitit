import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'notification_item.freezed.dart';
part 'notification_item.g.dart';

@unfreezed
class NotificationItem with _$NotificationItem {
  NotificationItem._();

  @HiveType(typeId: 4)
  factory NotificationItem({
    @HiveField(0) String? category,
    @HiveField(1) required Map<dynamic, dynamic> data,
    @HiveField(2) DateTime? sentAt,
    @HiveField(3) String? title,
    @HiveField(4) String? body,
    @HiveField(5) @Default(false) bool? isRead,
  }) = _NotificationItem;
}
