import 'package:habitit/data/habits/models/habit_model.dart';

abstract class HiveService {
  Future<void> addHabit({required HabitModel habit});
}
