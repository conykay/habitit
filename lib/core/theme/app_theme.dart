import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xffFFB200),
        primary: Color(0xffEB5B00),
        secondary: Color(0xffD91656),
        tertiary: Color(0xff640D5F),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20)),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.2),
        labelStyle: TextStyle(fontSize: 20),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(60),
            textStyle: TextStyle(fontSize: 20)),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: Color(0xffFFB200),
        primary: Color(0xffEB5B00),
        secondary: Color(0xffD91656),
        tertiary: Color(0xff640D5F),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20)),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.2),
        labelStyle: TextStyle(fontSize: 20),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(60),
            textStyle: TextStyle(fontSize: 20)),
      ),
    );
  }
}
