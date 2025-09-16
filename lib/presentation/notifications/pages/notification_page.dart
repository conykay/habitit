import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/presentation/notifications/bloc/notification_cubit.dart';
import 'package:habitit/presentation/notifications/bloc/notification_state.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit()..markAllAsRead(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Notifications'),
            actions: [
              Builder(builder: (context) {
                return TextButton(
                  onPressed: () =>
                      context.read<NotificationCubit>().clearNotifications(),
                  child: Text('Clear'),
                );
              })
            ],
          ),
          body: LayoutBuilder(builder: (context, constrains) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: BlocBuilder<NotificationCubit, NotificationState>(
                    builder: (context, state) {
                  if (state.notifications.isEmpty) {
                    return Center(
                      child: Text('No notifications'),
                    );
                  }
                  var reversedNotifications =
                      state.notifications.reversed.toList();
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        var notification = reversedNotifications[index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              color: notification.isRead!
                                  ? Colors.white
                                  : Colors.blue.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(notification.title!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(notification.body!),
                              Text(
                                DateTime(
                                        notification.sentAt!.month,
                                        notification.sentAt!.day,
                                        notification.sentAt!.hour,
                                        notification.sentAt!.minute)
                                    .toString(),
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemCount: state.notifications.length);
                }),
              ),
            );
          })),
    );
  }
}
