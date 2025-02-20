import 'package:dartz/dartz.dart';
import 'package:habitit/data/habits/models/habit_model.dart';

abstract class HabitRepository {
  Future<Either> addHabit({required HabitModel habit});
  Future<Either> getAllHabits();
  Future<Either> getHabit({required String id});
}
