// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum NavItem {
  home,
  habits,
  analytics,
  profile,
}

class NavigationData {
  final IconData icon;
  final String label;
  final String appBarTitle;
  NavigationData({
    required this.icon,
    required this.label,
    required this.appBarTitle,
  });
}

List<NavigationData> navData = [
  NavigationData(
      icon: FontAwesomeIcons.house, label: 'Home', appBarTitle: 'Home'),
  NavigationData(
      icon: FontAwesomeIcons.recycle, label: 'Habits', appBarTitle: 'Habits'),
  NavigationData(
      icon: FontAwesomeIcons.chartPie,
      label: 'Analytics',
      appBarTitle: 'Analytics'),
  NavigationData(
      icon: FontAwesomeIcons.user, label: 'Profile', appBarTitle: 'Profile'),
];
