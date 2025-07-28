// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/common/auth/auth_state.dart';
import 'package:habitit/common/auth/auth_state_cubit.dart';
import 'package:habitit/common/navigation/navigation_state.dart';
import 'package:habitit/common/navigation/navigation_state_cubit.dart';
import 'package:habitit/core/navigation/app_navigator.dart';
import 'package:habitit/core/navigation/navigation.dart';
import 'package:habitit/data/notifications/source/firebase_messaging_service.dart';
import 'package:habitit/presentation/auth/pages/signin_page.dart';
import 'package:habitit/presentation/notifications/bloc/notification_cubit.dart';
import 'package:habitit/presentation/notifications/bloc/notification_state.dart';
import 'package:habitit/presentation/notifications/pages/notification_page.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_cubit.dart';

import '../../../service_locator.dart';
import '../../analytics/pages/analytics_page.dart';
import '../../habits/bloc/habit_state_cubit.dart';
import '../../habits/bloc/selected_frequency_cubit.dart';
import '../../habits/pages/habits_page.dart';
import '../../home/pages/home_page.dart';
import '../../profile/pages/profile_page.dart';
import '../widgets/custom_top_navigator.dart';

class NavigationBasePage extends StatefulWidget {
  NavigationBasePage({super.key});

  @override
  State<NavigationBasePage> createState() => _NavigationBasePageState();
}

class _NavigationBasePageState extends State<NavigationBasePage> {
  final List<Widget> pages = [
    HomePage(),
    HabitsPage(),
    AnalyticsPage(),
    ProfilePage(),
  ];

  Future<void> getPermissions() async {
    await sl.get<NotificationService>().grantAppPermission();
  }

  @override
  void initState() {
    getPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationStateCubit()),
        BlocProvider(create: (context) => SelectedFrequencyCubit()),
        BlocProvider(create: (context) => HabitStateCubit()),
        BlocProvider(create: (context) => UserRewardsCubit()),
        BlocProvider(create: (context) => NotificationCubit())
      ],
      child: BlocListener<AuthStateCubit, AuthState>(
        listenWhen: (prev, current) {
          return current is UnAuthenticated;
        },
        listener: (context, state) {
          switch (state) {
            case UnAuthenticated():
              AppNavigator.pushAndRemove(context, SignInPage());
              break;
            default:
              break;
          }
        },
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            return _largeDeviceLayout();
          } else {
            return _smallDeviceLayout();
          }
        }),
      ),
    );
  }

  Scaffold _largeDeviceLayout() {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: BlocBuilder<NavigationStateCubit, NavigationState>(
                builder: (context, state) {
              var title = navData[state.index].appBarTitle;
              return AppBar(
                title: Text(title),
                actions: [
                  ...navData.map(
                    (e) => CustomTopNavigator(navdata: e, index: state.index),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: BlocBuilder<NotificationCubit, NotificationState>(
                      builder: (context, state) {
                        return Stack(
                          children: [
                            IconButton(
                                onPressed: () {
                                  AppNavigator.push(
                                      context,
                                      BlocProvider.value(
                                          value:
                                              context.read<NotificationCubit>(),
                                          child: NotificationPage()));
                                },
                                icon: FaIcon(FontAwesomeIcons.bell)),
                            state.notifications.isNotEmpty
                                ? Positioned(
                                    right: 11,
                                    top: 11,
                                    child: Container(
                                      padding: EdgeInsets.all(3),
                                      constraints: BoxConstraints(
                                          minWidth: 10, minHeight: 10),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
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
                    ),
                  )
                ],
              );
            })),
        body: BlocBuilder<NavigationStateCubit, NavigationState>(
          builder: (context, state) {
            return pages[state.index];
          },
        ));
  }

  Scaffold _smallDeviceLayout() {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: BlocBuilder<NavigationStateCubit, NavigationState>(
              builder: (context, state) {
            var title = navData[state.index].appBarTitle;
            return AppBar(
              title: Text(title),
              actions: [
                BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, state) {
                    return Stack(
                      children: [
                        IconButton(
                            onPressed: () {
                              AppNavigator.push(
                                  context,
                                  BlocProvider.value(
                                      value: context.read<NotificationCubit>(),
                                      child: NotificationPage()));
                            },
                            icon: FaIcon(FontAwesomeIcons.bell)),
                        state.notifications.isNotEmpty
                            ? Positioned(
                                right: 11,
                                top: 11,
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  constraints: BoxConstraints(
                                      minWidth: 10, minHeight: 10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
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
                ),
              ],
            );
          })),
      body: BlocBuilder<NavigationStateCubit, NavigationState>(
        builder: (context, state) {
          return pages[state.index];
        },
      ),
      bottomNavigationBar: BlocBuilder<NavigationStateCubit, NavigationState>(
          builder: (context, state) {
        return NavigationBar(
          selectedIndex: state.index,
          destinations: navData
              .map((e) => NavigationDestination(
                    icon: FaIcon(
                      e.icon,
                      color: Colors.grey,
                    ),
                    label: e.label,
                    selectedIcon: FaIcon(
                      e.icon,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ))
              .toList(),
          onDestinationSelected: (index) {
            context
                .read<NavigationStateCubit>()
                .getNavBarItem(NavItem.values[index]);
          },
        );
      }),
    );
  }
}
