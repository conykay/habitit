// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:habitit/common/navigation/navigation_state_cubit.dart';
import 'package:habitit/core/navigation/navigation.dart';
import 'package:habitit/presentation/notifications/bloc/notification_cubit.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_cubit.dart';

import '../../../data/notifications/source/notification_service.dart';
import '../../../service_locator.dart';
import '../../habits/bloc/habit_state_cubit.dart';
import '../../habits/bloc/selected_frequency_cubit.dart';
import '../widgets/notification_Icon.dart';

class NavigationBasePage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const NavigationBasePage(this.navigationShell, {super.key});

  @override
  State<NavigationBasePage> createState() => _NavigationBasePageState();
}

class _NavigationBasePageState extends State<NavigationBasePage> {
  Future<void> getPermissions() async {
    await sl.get<NotificationService>().grantAppPermission();
  }

  @override
  void initState() {
    getPermissions();
    super.initState();
  }

  @override
  void dispose() {
    _disposables();
    super.dispose();
  }

  void _disposables() async {
    HabitStateCubit().habitsSubscription.cancel();
    UserRewardsCubit().rewardSubscription.cancel();
    await NotificationCubit().close();
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(navData[widget.navigationShell.currentIndex].appBarTitle),
          actions: [
            NotificationIcon(),
          ],
        ),
        body: widget.navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
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
          onDestinationSelected: _onTap,
        ),
      ),
    );
  }

  void _onTap(index) async {
    widget.navigationShell.goBranch(index,
        initialLocation: index == widget.navigationShell.currentIndex);
  }
}

//Todo: Re-integrate support for different screen sizes.
/*
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
        return _pages[state.index];
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
          return _pages[state.index];
        },
      ));
}*/
