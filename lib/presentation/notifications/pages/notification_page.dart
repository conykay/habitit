import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/presentation/notifications/bloc/notification_cubit.dart';
import 'package:habitit/presentation/notifications/bloc/notification_state.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
          actions: [
            TextButton(
              onPressed: () =>
                  context.read<NotificationCubit>().clearNotifications(),
              child: Text('Clear'),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Text('No notifications'),
              );
            }
            var reversedNotifications = state.notifications.reversed.toList();
            return ListView.separated(
                itemBuilder: (context, index) {
                  var notification = reversedNotifications[index];
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(notification),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: state.notifications.length);
          }),
        ));
  }
}
