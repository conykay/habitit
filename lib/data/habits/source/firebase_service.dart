import 'package:habitit/data/habits/models/habit_model.dart';

abstract class FirebaseService {
  Future<void> addHabit({required HabitModel habit});
}
