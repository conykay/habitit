import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeTableCalendarWidget extends StatelessWidget {
  const HomeTableCalendarWidget({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(Duration(days: 7)),
      calendarFormat: CalendarFormat.week,
      headerVisible: false,
      rowHeight: 70,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
            color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
