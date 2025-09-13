// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:habitit/domain/habits/entities/habit_entity.dart';

sealed class HabitState {}

class HabitInitial extends HabitState {}

class HabitLoading extends HabitState {
  List<HabitEntity>? oldHabits;

  HabitLoading({this.oldHabits});
}

class HabitLoaded extends HabitState {
  final List<HabitEntity> habits;

  HabitLoaded({required this.habits});
}

class HabitError extends HabitState {
  final String message;

  HabitError({
    required this.message,
  });
}
