import 'package:dartz/dartz.dart';
import 'package:habitit/data/habits/models/habit_model.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';

abstract class HabitsRepository {
  Future<Either> addHabit({required HabitModel habit});
  Future<Either> getAllHabits();
  Future<Either> getHabit({required String id});
  Future<Either> editHabit({required HabitEntity habit});
  Future<Either> deleteHabit({required HabitEntity habit});
}
