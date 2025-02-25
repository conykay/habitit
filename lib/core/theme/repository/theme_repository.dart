import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';

final _IS_DARK_THEME = "IS_DARK_THEME";

class ThemeRepository {
  Future<void> init() async {
    await Hive.openBox<bool>(_IS_DARK_THEME);
  }

  Future<bool> getTheme() async {
    var box = await Hive.openBox<bool>(_IS_DARK_THEME);
    if (box.isEmpty) {
      return SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return box.get(_IS_DARK_THEME) ?? false;
  }

  Future<void> setTheme({required bool isDarkTheme}) async {
    var box = await Hive.openBox<bool>(_IS_DARK_THEME);
    box.put(_IS_DARK_THEME, isDarkTheme);
  }
/*   Future<bool> getTheme() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_IS_DARK_THEME) ??
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
  }

  Future<void> setTheme({required bool isDarkTheme}) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(_IS_DARK_THEME, isDarkTheme);
  } */
}
