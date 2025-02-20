import 'package:habitit/data/habits/models/habit_model.dart';
import 'package:hive/hive.dart';

Future<void> registerHiveAdapters() async {
  Hive.registerAdapter(HabitModelAdapter());
}
