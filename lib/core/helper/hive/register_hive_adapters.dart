import 'package:habitit/data/habits/models/habit_model.dart';
import 'package:hive/hive.dart';

void registerHiveAdapters() {
  Hive.registerAdapter(HabitModelAdapter());
}
