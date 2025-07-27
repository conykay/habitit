import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service_locator.dart';
import '../repository/theme_repository.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState());
  static late bool _isDarkTheme;
  final _themeRepository = sl.get<ThemeRepository>();

  Future<void> getCurrentTheme() async {
    _themeRepository.getTheme().then((isDarkTheme) {
      if (isDarkTheme) {
        _isDarkTheme = true;
        emit(state.copyWith(themeMode: ThemeMode.dark));
      } else {
        _isDarkTheme = false;
        emit(state.copyWith(themeMode: ThemeMode.light));
      }
    });
  }

  Future<void> switchTheme() async {
    if (_isDarkTheme) {
      await _themeRepository.setTheme(isDarkTheme: false);
      _isDarkTheme = false;
      emit(state.copyWith(themeMode: ThemeMode.light));
    } else {
      await _themeRepository.setTheme(isDarkTheme: true);
      _isDarkTheme = true;
      emit(state.copyWith(themeMode: ThemeMode.dark));
    }
  }
}
