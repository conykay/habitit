// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
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
        return Stack(
          children: [
            IconButton(
                onPressed: () {
                  context.pushNamed(AppRoutes.notifications);
                },
                icon: FaIcon(FontAwesomeIcons.bell)),
            state.notifications.isNotEmpty
                ? Positioned(
                    right: 11,
                    top: 11,
                    child: Container(
                      padding: EdgeInsets.all(3),
                      constraints: BoxConstraints(minWidth: 10, minHeight: 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.secondary),
                      child: Text(
                        state.notifications.length.toString(),
                        style: TextStyle(fontSize: 10),
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
