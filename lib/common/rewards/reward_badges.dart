import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/data/rewards/models/badge_model.dart';

List<BadgeModel> badges = [
  BadgeModel(
      id: 'first_habit',
      name: 'One Small Step',
      description: 'Created your first habit',
      icon: FontAwesomeIcons.hourglassStart,
      colors: [
        const Color.fromARGB(255, 215, 26, 12),
        const Color.fromARGB(255, 82, 2, 2),
      ]),
  BadgeModel(
      id: 'week_streak',
      name: 'I\'m Not Week',
      description: 'Completed a one week streak',
      icon: FontAwesomeIcons.seven,
      colors: [
        const Color.fromARGB(255, 11, 128, 225),
        const Color.fromARGB(255, 3, 6, 100),
      ]),
  BadgeModel(
      id: 'month_streak',
      name: 'Month My Business',
      description: 'Completed a one month streak',
      icon: FontAwesomeIcons.calendarCheck,
      colors: [
        const Color.fromARGB(255, 9, 167, 156),
        const Color.fromARGB(255, 3, 71, 78),
      ]),
  BadgeModel(
      id: 'level_ten',
      name: 'Ten Toes Down',
      description: 'Reached level ten',
      icon: FontAwesomeIcons.basketball,
      colors: [
        const Color.fromARGB(255, 182, 201, 9),
        const Color.fromARGB(255, 79, 86, 4)
      ]),
  BadgeModel(
      id: 'level_up',
      name: 'This Is Easy',
      description: 'Got past level one',
      icon: FontAwesomeIcons.baby,
      colors: [
        const Color.fromARGB(255, 201, 9, 188),
        const Color.fromARGB(255, 57, 4, 86)
      ]),
  BadgeModel(
      id: 'level_100',
      name: 'I Can\'t Stop',
      description: 'Created your first habit',
      colors: [
        const Color.fromARGB(255, 243, 189, 13),
        const Color.fromARGB(255, 116, 88, 3)
      ]),
];
