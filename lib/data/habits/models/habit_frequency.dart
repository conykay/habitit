import 'package:hive/hive.dart';

part 'habit_frequency.g.dart';

@HiveType(typeId: 1)
enum HabitFrequency {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
}
