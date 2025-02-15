import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/core/theme/repository/theme_repository.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required ThemeRepository themeRepository})
      : _themeRepository = themeRepository,
        super(ThemeState());
  final ThemeRepository _themeRepository;
  static late bool _isDarkTheme;

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
