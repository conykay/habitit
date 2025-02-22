import 'package:habitit/domain/habits/entities/habit_enity.dart';

int calculateCurrentStreak(List<DateTime> completedDates) {
  if (completedDates.isEmpty) return 0;

  List<DateTime> normalizedDates = completedDates
      .map((d) => DateTime(d.year, d.month, d.day))
      .toList()
    ..sort();

  DateTime today = DateTime.now();
  DateTime lastDate = normalizedDates.last;

  if (today.difference(lastDate).inDays > 0) return 0;

  int streak = 1;
  for (int i = normalizedDates.length - 2; i >= 0; i--) {
    DateTime current = normalizedDates[i];
    DateTime next = normalizedDates[i + 1];
    if (next.difference(current).inDays == 1) {
      streak++;
    } else {
      break;
    }
  }
  return streak;
}

int calculateLongestStreak(List<DateTime> completedDates) {
  if (completedDates.isEmpty) return 0;

  final normalizedDates = completedDates
      .map((d) => DateTime(d.year, d.month, d.day))
      .toSet()
      .toList()
    ..sort();

  int longestStreak = 1;
  int currentStreak = 1;

  for (int i = 1; i < normalizedDates.length; i++) {
    final previous = normalizedDates[i - 1];
    final current = normalizedDates[i];

    if (current.difference(previous).inDays == 1) {
      currentStreak++;
    } else {
      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }
      currentStreak = 1;
    }
  }

  if (currentStreak > longestStreak) {
    longestStreak = currentStreak;
  }

  return longestStreak;
}

int longestStreakInAllHabits(List<HabitEnity> habits) {
  var longestStreak = 0;
  var highestStreak = 0;
  for (var habit in habits) {
    longestStreak = calculateLongestStreak(habit.completedDates!);
    if (longestStreak > highestStreak) {
      highestStreak = longestStreak;
    }
  }
  return highestStreak;
}

double calculateAdherenceRate(HabitEnity habit) {
  final normalizedStart = DateTime(habit.startDate.toDate().year,
      habit.startDate.toDate().month, habit.startDate.toDate().day);
  final today = DateTime.now();
  final normalizedToday = DateTime(today.year, today.month, today.day);

  final totalDays = normalizedToday.difference(normalizedStart).inDays + 1;

  final completedDaysSet = habit.completedDates!
      .map((d) => DateTime(d.year, d.month, d.day))
      .toSet();

  if (totalDays <= 0) return 0.0;
  return (completedDaysSet.length / totalDays) * 100;
}

Map<DateTime, int> getDailyCompletionData(
  List<HabitEnity> habits, {
  DateTime? start,
  DateTime? end,
}) {
  DateTime normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  final today = normalize(DateTime.now());
  end = end != null ? normalize(end) : today;

  if (start == null) {
    if (habits.isEmpty) return {};
    start = habits
        .map((h) => normalize(h.startDate.toDate()))
        .reduce((a, b) => a.isBefore(b) ? a : b);
  } else {
    start = normalize(start);
  }

  Map<DateTime, int> dailyData = {};
  for (DateTime date = start;
      !date.isAfter(end);
      date = date.add(Duration(days: 1))) {
    dailyData[date] = 0;
  }

  for (final habit in habits) {
    for (final d in habit.completedDates!) {
      final normalized = normalize(d);
      if (normalized.isBefore(start) || normalized.isAfter(end)) continue;
      dailyData[normalized] = (dailyData[normalized] ?? 0) + 1;
    }
  }

  return dailyData;
}
