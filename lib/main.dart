import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habitit/common/auth/auth_state_cubit.dart';
import 'package:habitit/core/theme/app_theme.dart';
import 'package:habitit/core/theme/bloc/theme_cubit.dart';
import 'package:habitit/data/notifications/models/notification_item.dart';
import 'package:habitit/data/notifications/source/notification_service.dart';
import 'package:habitit/domain/habits/entities/habit_entity.dart';
import 'package:habitit/domain/quotes/entities/quotes_entity.dart';
import 'package:habitit/domain/rewards/entities/user_reward_entity.dart';
import 'package:habitit/firebase_options.dart';
import 'package:habitit/service_locator.dart';
import 'package:hive_flutter/adapters.dart';

import 'core/navigation/app_router.dart';
import 'data/habits/models/habit_frequency.dart';
import 'data/notifications/source/notifications_hive_service.dart';

Future<void> _backgroundHandler(RemoteMessage message) async {
  try {
    await initializeGetItDependencies();
    final hiveService = await sl.getAsync<NotificationHiveService>();
    await hiveService.addNotification(message);
  } catch (e) {
    print('Error in background Handler: $e');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //initialize hive
  await Hive.initFlutter();
  //initialize service locator
  await initializeGetItDependencies();
  // retrieve device token
  await sl.get<NotificationService>().getToken();
  //request notification permissions
  await sl.get<NotificationService>().grantAppPermission();
  //handle background messages
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  //Register hive adapters
  Hive.registerAdapter(HabitEntityImplAdapter());
  Hive.registerAdapter(HabitFrequencyAdapter());
  Hive.registerAdapter(UserRewardEntityImplAdapter());
  Hive.registerAdapter(QuotesEntityImplAdapter());
  Hive.registerAdapter(NotificationItemImplAdapter());

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _route;
  late final AuthStateCubit _authStateCubit;

  @override
  void initState() {
    super.initState();
    _authStateCubit = AuthStateCubit();
    _route = AppRouter.getRouter(_authStateCubit);
  }

  @override
  void dispose() {
    _disposables();
    super.dispose();
  }

  void _disposables() {
    _authStateCubit.close();
    sl.get<NotificationService>().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()..getCurrentTheme()),
        BlocProvider.value(value: _authStateCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
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
      ),
    );
  }
}

/*
*  todo: 2. remove sync manager and find better way to implement offline first.
*   todo: 3. refactor bloc classes.
* */
