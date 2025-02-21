import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';
import 'package:habitit/presentation/home/bloc/mark_habit_complete_sate.dart';

class MarkHabitCompleteCubit extends Cubit<MarkHabitCompleteSate> {
  final HabitRepository repository;
  MarkHabitCompleteCubit(this.repository) : super(MarkHabitInital());

  void get habitState => state;

  void markComplete({required HabitEnity habit}) async {
    emit(MarkHabitLoading());
    Either done = await repository.editHabit(habit: habit);
    done.fold(
      (l) => emit(MarkHabitFailed(error: l)),
      (r) => emit(MarkHabitLoaded()),
    );
  }
}
