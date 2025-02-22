import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../domain/habits/entities/habit_enity.dart';

class HabitCalendarWidget extends StatelessWidget {
  const HabitCalendarWidget({
    super.key,
    required this.habit,
  });

  final HabitEnity habit;

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Map<DateTime, List<String>> _buildEventMap() {
    final Map<DateTime, List<String>> events = {};
    for (var date in habit.completedDates!) {
      final normalized = normalizeDate(date);
      if (events[normalized] == null) {
        events[normalized] = [];
      }
      events[normalized]!.add('completed');
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    final events = _buildEventMap();
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2100, 1, 1),
      headerVisible: true,
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        markerSize: 0,
      ),
      eventLoader: (day) {
        return events[normalizeDate(day)] ?? [];
      },
      calendarBuilders:
          CalendarBuilders(defaultBuilder: (context, day, focusedDay) {
        final eventsForDay = events[normalizeDate(day)] ?? [];
        if (eventsForDay.isNotEmpty) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: Text(
              '${day.day}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
        return null;
      }),
    );
  }
}
