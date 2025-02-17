import 'package:flutter/material.dart';

class AppNavigator {
  static void push(context, page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static void pushReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }

  static void pushAndRemove(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => page),
        (Route<dynamic> route) => false);
  }
}
