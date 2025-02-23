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
import 'package:habitit/core/network/network_info.dart';
import 'package:habitit/data/rewards/repository/rewards_repository.dart';
import 'package:habitit/data/rewards/sources/rewards_firebase_service.dart';
import 'package:habitit/data/rewards/sources/rewards_hive_service.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';
import 'package:habitit/domain/rewards/repository/rewards_repository.dart';
import 'package:habitit/presentation/auth/pages/signin_page.dart';
import 'package:habitit/presentation/notifications/pages/notification_page.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_cubit.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../data/habits/repository/habits_repository_impl.dart';
import '../../../data/habits/source/habits_firebase_service.dart';
import '../../../data/habits/source/habits_hive_service.dart';
import '../../analytics/pages/analytics_page.dart';
import '../../habits/bloc/habit_state_cubit.dart';
import '../../habits/bloc/selected_frequency_cubit.dart';
import '../../habits/pages/habits_page.dart';
import '../../home/pages/home_page.dart';
import '../../profile/pages/profile_page.dart';
import '../widgets/custom_top_navigator.dart';

class NavigationBasePage extends StatelessWidget {
  NavigationBasePage({super.key});

  final List<Widget> pages = [
    HomePage(),
    HabitsPage(),
    AnalyticsPage(),
    ProfilePage(),
  ];

  final habitsHiveService = HabitsHiveServiceImpl();
  final habitsFirebaseService = HabitsFirebaseServiceImpl();
  final rewardsHiveService = RewardsHiveServiceImpl();
  final rewardsFirebaseService = RewardsFirebaseServiceImpl();
  final networkInfo = NetworkInfoImpl(
      internetConnectionChecker: InternetConnectionChecker.instance);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HabitRepository>(
          create: (context) => HabitsRepositoryImpl(
              hiveService: habitsHiveService,
              firebaseService: habitsFirebaseService,
              networkInfo: networkInfo),
        ),
        RepositoryProvider<RewardsRepository>(
          create: (context) => RewardsRepositoryImpl(
              hiveService: rewardsHiveService,
              firebaseService: rewardsFirebaseService,
              networkInfo: networkInfo),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NavigationStateCubit(),
          ),
          BlocProvider(
            create: (context) => SelectedFrequencyCubit(),
          ),
          BlocProvider(
            create: (context) => HabitStateCubit(),
          ),
          BlocProvider(create: (context) => UserRewardsCubit())
        ],
        child: BlocListener<AuthStateCubit, AuthState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              AppNavigator.pushAndRemove(context, SigninPage());
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
                    child: IconButton(
                        onPressed: () {
                          AppNavigator.push(context, NotificationPage());
                        },
                        icon: FaIcon(FontAwesomeIcons.bell)),
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
                IconButton(
                    onPressed: () {
                      AppNavigator.push(context, NotificationPage());
                    },
                    icon: FaIcon(FontAwesomeIcons.bell))
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
