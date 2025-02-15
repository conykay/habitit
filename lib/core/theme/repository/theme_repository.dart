import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _IS_DARK_THEME = "IS_DARK_THEME";

class ThemeRepository {
  Future<bool> getTheme() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_IS_DARK_THEME) ??
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
  }

  Future<void> setTheme({required bool isDarkTheme}) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(_IS_DARK_THEME, isDarkTheme);
  }
}
