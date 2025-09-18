import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:habitit/common/auth/auth_state.dart';
import 'package:habitit/core/navigation/stream_to_listenable.dart';
import 'package:habitit/domain/habits/entities/habit_entity.dart';
import 'package:habitit/presentation/analytics/pages/analytics_page.dart';
import 'package:habitit/presentation/auth/pages/signin_page.dart';
import 'package:habitit/presentation/auth/pages/signup_page.dart';
import 'package:habitit/presentation/habits/pages/habit_details_page.dart';
import 'package:habitit/presentation/habits/pages/habits_page.dart';
import 'package:habitit/presentation/home/pages/home_page.dart';
import 'package:habitit/presentation/navigation/pages/navigation_base_page.dart';
import 'package:habitit/presentation/notifications/pages/notification_page.dart';
import 'package:habitit/presentation/profile/pages/profile_page.dart';

import '../../common/auth/auth_state_cubit.dart';

class AppRoutes {
  // Consider renaming the class holding route names for clarity
  static const String signIn = 'signIn'; // Names don't need the '/'
  static const String signUp = 'signUp';
  static const String navigation =
      'navigation'; // Although this is a shell, you might not navigate to it directly by name
  static const String home = 'home';
  static const String habits = 'habits';
  static const String profile = 'profile';
  static const String analytics = 'analytics';
  static const String habitDetails = 'habitDetails';
  static const String notifications = 'notifications';
}

enum AppRoute {
  signIn('/signIn'),
  signUp('/signUp'),
  navigation('/navigation'),
  home('/'),
  habits('/habits'),
  profile('/profile'),
  analytics('/analytics'),
  habitDetails('details'),
  notifications('/notifications');

  const AppRoute(this.path);

  final String path;
}

class AppRouter {
  static GoRouter getRouter(AuthStateCubit authBloc) {
    return GoRouter(
      routes: [
        GoRoute(
            path: AppRoute.signIn.path,
            name: AppRoutes.signIn,
            builder: (context, state) => SignInPage()),
        GoRoute(
            path: AppRoute.signUp.path,
            name: AppRoutes.signUp,
            builder: (context, state) => SignupPage()),
        //notifications
        GoRoute(
            path: AppRoute.notifications.path,
            name: AppRoutes.notifications,
            builder: (context, state) => NotificationPage()),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return NavigationBasePage(navigationShell);
          },
          branches: [
            //home
            StatefulShellBranch(
              initialLocation: AppRoute.home.path,
              routes: [
                GoRoute(
                  path: AppRoute.home.path,
                  name: AppRoutes.home,
                  builder: (context, state) => HomePage(),
                ),
              ],
            ),
            //habits
            StatefulShellBranch(
              initialLocation: AppRoute.habits.path,
              routes: [
                GoRoute(
                    path: AppRoute.habits.path,
                    name: AppRoutes.habits,
                    builder: (context, state) => HabitsPage(),
                    routes: [
                      GoRoute(
                          path: AppRoute.habitDetails.path,
                          name: AppRoutes.habitDetails,
                          builder: (context, state) {
                            if (state.extra != null) {
                              final HabitEntity habit =
                                  state.extra as HabitEntity;
                              return HabitDetailsPage(habit: habit);
                            }
                            return ErrorWidget('could not retrieve habit');
                          })
                    ]),
              ],
            ),
            //analytics
            StatefulShellBranch(
              initialLocation: AppRoute.analytics.path,
              routes: [
                GoRoute(
                    path: AppRoute.analytics.path,
                    name: AppRoutes.analytics,
                    builder: (context, state) => AnalyticsPage())
              ],
            ),
            //profile
            StatefulShellBranch(
              initialLocation: AppRoute.profile.path,
              routes: [
                GoRoute(
                    path: AppRoute.profile.path,
                    name: AppRoutes.profile,
                    builder: (context, state) => ProfilePage())
              ],
            ),
          ],
        )
      ],
      refreshListenable: StreamToListenable(authBloc),
      redirect: (context, state) {
        final isAuthenticated = authBloc.state is Authenticated;
        final isGoingToAuth =
            state.matchedLocation.contains(AppRoute.signUp.path) ||
                state.matchedLocation.contains(AppRoute.signIn.path);

        if (isAuthenticated && isGoingToAuth) {
          return AppRoute.home.path;
        } else if (!isAuthenticated && !isGoingToAuth) {
          return AppRoute.signIn.path;
        }
        return null;
      },
    );
  }
}
