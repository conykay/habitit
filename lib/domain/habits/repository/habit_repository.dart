import 'package:dartz/dartz.dart';
import 'package:habitit/data/habits/models/habit_model.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';

abstract class HabitRepository {
  Future<Either> addHabit({required HabitModel habit});
  Future<Either> getAllHabits();
  Future<Either> getHabit({required String id});
  Future<Either> editHabit({required HabitEnity habit});
  Future<Either> deleteHabit({required HabitEnity habit});
}
