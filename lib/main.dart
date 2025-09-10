import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habitit/common/auth/auth_state_cubit.dart';
import 'package:habitit/core/theme/app_theme.dart';
import 'package:habitit/core/theme/bloc/theme_cubit.dart';
import 'package:habitit/data/notifications/source/local_notification_service.dart';
import 'package:habitit/data/notifications/source/notification_service.dart';
import 'package:habitit/domain/habits/entities/habit_entity.dart';
import 'package:habitit/domain/quotes/entities/quotes_entity.dart';
import 'package:habitit/domain/rewards/entities/user_reward_entity.dart';
import 'package:habitit/firebase_options.dart';
import 'package:habitit/service_locator.dart';
import 'package:hive_flutter/adapters.dart';

import 'core/navigation/app_router.dart';
import 'data/habits/models/habit_frequency.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await initializeGetItDependencies();
  await LocalNotificationService.initialize();
  await NotificationServiceImpl().getToken();
  Hive.registerAdapter(HabitEntityImplAdapter());
  Hive.registerAdapter(HabitFrequencyAdapter());
  Hive.registerAdapter(UserRewardEntityImplAdapter());
  Hive.registerAdapter(QuotesEntityImplAdapter());

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final GoRouter _route = AppRouter.getRouter(AuthStateCubit());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()..getCurrentTheme()),
        BlocProvider(create: (context) => AuthStateCubit()),
      ],
      child: Builder(builder: (context) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp.router(
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: state.themeMode,
              routeInformationProvider: _route.routeInformationProvider,
              routerDelegate: _route.routerDelegate,
              routeInformationParser: _route.routeInformationParser,
            );
          },
        );
      }),
    );
  }
}

/*
*  todo: 2. remove sync manager and find better way to implement offline first.
*   todo: 3. refactor bloc classes.
* */
