import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/core/theme/app_theme.dart';
import 'package:habitit/core/theme/bloc/theme_cubit.dart';
import 'package:habitit/presentation/auth/pages/signup_page.dart';

import 'core/theme/repository/theme_repository.dart';

void main() {
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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => ThemeCubit(themeRepository: _themeRepository)
                ..getCurrentTheme())
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
          return MaterialApp(
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: state.themeMode,
            home: SignupPage(),
          );
        }),
      ),
    );
  }
}
