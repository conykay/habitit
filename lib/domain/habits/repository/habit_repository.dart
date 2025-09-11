import 'package:dartz/dartz.dart';
import 'package:habitit/domain/habits/entities/habit_entity.dart';

abstract class HabitsRepository {
  Future<Either> addHabit({required HabitEntity habit});

  Stream<Either> getAllHabits();

  Future<Either> getHabit({required String id});

  Future<Either> editHabit({required HabitEntity habit});

  Future<Either> deleteHabit({required HabitEntity habit});
}
