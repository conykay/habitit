import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:habitit/data/notifications/models/notification_item.dart';
import 'package:habitit/presentation/notifications/bloc/notification_cubit.dart';
import 'package:habitit/presentation/notifications/bloc/notification_state.dart';

import '../../../core/navigation/app_router.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final List<NotificationItem> unreadNotification = state.notifications
            .where((notification) => !notification.isRead!)
            .toList();
        print('Unread notifications:: ${unreadNotification.length}');
        final bool isEmpty = unreadNotification.isNotEmpty;
        return Stack(
          children: [
            IconButton(
                onPressed: () {
                  context.pushNamed(AppRoutes.notifications);
                },
                icon: FaIcon(FontAwesomeIcons.bell)),
            isEmpty
                ? Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.secondary),
                      child: Text(
                        unreadNotification.length.toString(),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
