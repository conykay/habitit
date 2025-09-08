import 'package:habitit/domain/habits/entities/habit_entity.dart';
import 'package:hive/hive.dart';

Future<void> registerHiveAdapters() async {
  Hive.registerAdapter(HabitEntityImplAdapter());
}
