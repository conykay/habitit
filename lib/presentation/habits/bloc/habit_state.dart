// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:habitit/domain/habits/entities/habit_enity.dart';

abstract class HabitState {}

class HabitInitial extends HabitState {}

class HabitLoading extends HabitState {}

class HabitLoaded extends HabitState {
  final List<HabitEnity> habits;

  HabitLoaded({required this.habits});
}

class HabitError extends HabitState {
  final String message;
  HabitError({
    required this.message,
  });
}
