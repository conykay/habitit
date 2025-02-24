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
        body: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
          if (state.notifications.isEmpty) {
            return Center(
              child: Text('No notifications'),
            );
          }
          return ListView.separated(
              itemBuilder: (context, index) => Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.orange.withValues(alpha: 0.2),
                    child: Text(state.notifications[index]),
                  ),
              separatorBuilder: (context, index) => SizedBox(height: 20),
              itemCount: state.notifications.length);
        }));
  }
}
