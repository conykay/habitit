import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeTableCalendarWidget extends StatelessWidget {
  const HomeTableCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final lastDay = date.add(Duration(days: 7));
    return TableCalendar(
      focusedDay: date,
      firstDay: date,
      lastDay: lastDay,
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
