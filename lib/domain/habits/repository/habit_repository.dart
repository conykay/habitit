import 'package:dartz/dartz.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';

abstract class HabitRepository {
  Future<Either> addHabit({required HabitEnity habit});
}
