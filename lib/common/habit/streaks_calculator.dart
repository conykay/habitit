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
