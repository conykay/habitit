// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:habitit/common/navigation/navigation_state.dart';
import 'package:habitit/common/navigation/navigation_state_cubit.dart';
import 'package:habitit/core/navigation/app_navigator.dart';
import 'package:habitit/core/navigation/navigation.dart';
import 'package:habitit/core/network/network_info.dart';
import 'package:habitit/presentation/notifications/pages/notification_page.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../data/habits/repository/habits_repository_impl.dart';
import '../../../data/habits/source/firebase_service.dart';
import '../../../data/habits/source/hive_service.dart';
import '../../../domain/habits/usecases/get_all_habits_usecase.dart';
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

  final hiveService = HiveServiceImpl();
  final firebaseService = FirebaseServiceImpl();
  final internet = InternetConnectionChecker.createInstance();
  final networkInfo = NetworkInfoImpl(
      internetConnectionChecker: InternetConnectionChecker.instance);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => HabitsRepositoryImpl(
              hiveService: hiveService,
              firebaseService: firebaseService,
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
              create: (context) => HabitStateCubit(
                  usecase: GetAllHabitsUsecase(
                      repository: context.read<HabitsRepositoryImpl>()))),
        ],
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
