import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/common/auth/auth_state.dart';
import 'package:habitit/common/auth/auth_state_cubit.dart';
import 'package:habitit/core/navigation/app_navigator.dart';
import 'package:habitit/core/sync/sync_coordinator.dart';
import 'package:habitit/core/theme/app_theme.dart';
import 'package:habitit/core/theme/bloc/theme_cubit.dart';
import 'package:habitit/data/habits/models/habit_model.dart';
import 'package:habitit/data/habits/source/habits_firebase_service.dart';
import 'package:habitit/data/notifications/source/firebase_messaging_service.dart';
import 'package:habitit/data/notifications/source/local_notification_service.dart';
import 'package:habitit/data/rewards/models/user_rewards_model.dart';
import 'package:habitit/firebase_options.dart';
import 'package:habitit/presentation/auth/pages/signup_page.dart';
import 'package:habitit/presentation/navigation/pages/navigation_base_page.dart';
import 'package:habitit/service_locator.dart';
import 'package:hive_flutter/adapters.dart';

import 'data/habits/models/habit_frequency.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await initializeGetItDependencies();
  await LocalNotificationService.initialize();
  await NotificationService().getToken();
  Hive.registerAdapter(HabitModelAdapter());
  Hive.registerAdapter(HabitFrequencyAdapter());
  Hive.registerAdapter(UserRewardsModelAdapter());
  //open hive boxes
  final habitBox = await Hive.openBox<HabitModel>('Habits');

  final habitsFirebaseService = HabitsFirebaseServiceImpl();
  final habitSyncCoordinator = SyncCoordinator(
    firebaseService: habitsFirebaseService,
    habitBox: habitBox,
  );
  habitSyncCoordinator.initialize();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()..getCurrentTheme()),
        BlocProvider(create: (context) => AuthStateCubit()..isAuthenticated()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: state.themeMode,
            home: BlocListener<AuthStateCubit, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  AppNavigator.pushReplacement(context, NavigationBasePage());
                }
                if (state is UnAuthenticated) {
                  AppNavigator.pushReplacement(context, SignupPage());
                }
              },
              child: Scaffold(body: Center(child: CircularProgressIndicator())),
            ),
          );
        },
      ),
    );
  }
}

/*todo: 1. remove excess dependency injection using get it.
*  todo: 2. remove sync manager and find better way to implement offline first.
*   todo: 3. refactor bloc classes.
* */
