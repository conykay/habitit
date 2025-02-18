import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/common/auth/auth_state.dart';
import 'package:habitit/common/auth/auth_state_cubit.dart';
import 'package:habitit/core/navigation/app_navigator.dart';
import 'package:habitit/core/network/network_info.dart';
import 'package:habitit/core/theme/app_theme.dart';
import 'package:habitit/core/theme/bloc/theme_cubit.dart';
import 'package:habitit/domain/auth/usecases/user_logged_in.dart';
import 'package:habitit/firebase_options.dart';
import 'package:habitit/presentation/auth/pages/signup_page.dart';
import 'package:habitit/presentation/home/pages/home_page.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/theme/repository/theme_repository.dart';
import 'data/auth/repository/authentication_repository_impl.dart';
import 'data/auth/sources/auth_firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MainApp(
    themeRepository: ThemeRepository(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({required ThemeRepository themeRepository, super.key})
      : _themeRepository = themeRepository;

  final ThemeRepository _themeRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ThemeRepository>(
            create: (context) => _themeRepository),
        RepositoryProvider<AuthenticationRepositoryImpl>(
          create: (context) => AuthenticationRepositoryImpl(
              firebaseService: AuthFirebaseServiceImpl(
                firestore: FirebaseFirestore.instance,
                auth: FirebaseAuth.instance,
              ),
              networkInfo: NetworkInfoImpl(
                internetConnectionChecker: InternetConnectionChecker.instance,
              )),
        )
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) =>
                    ThemeCubit(themeRepository: _themeRepository)
                      ..getCurrentTheme()),
            BlocProvider(
                create: (context) => AuthStateCubit(UserLoggedInUseCase(
                    context.read<AuthenticationRepositoryImpl>()))
                  ..isAutheniticated()),
          ],
          child: BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
            return MaterialApp(
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: state.themeMode,
              home: BlocListener<AuthStateCubit, AuthState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    AppNavigator.pushReplacement(context, HomePage());
                  }
                  if (state is UnAuthenticated) {
                    AppNavigator.pushReplacement(context, SignupPage());
                  }
                },
                child: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            );
          })),
    );
  }
}
