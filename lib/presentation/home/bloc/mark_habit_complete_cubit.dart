import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';
import 'package:habitit/presentation/home/bloc/mark_habit_complete_sate.dart';

import '../../../domain/habits/entities/habit_entity.dart';
import '../../../service_locator.dart';

class MarkHabitCompleteCubit extends Cubit<MarkHabitCompleteSate> {
  MarkHabitCompleteCubit() : super(MarkHabitInital());

  void get habitState => state;

  void markComplete({required HabitEntity habit}) async {
    emit(MarkHabitLoading());
    Either done = await sl.get<HabitsRepository>().editHabit(habit: habit);
    done.fold(
      (l) => emit(MarkHabitFailed(error: l)),
      (r) => emit(MarkHabitLoaded()),
    );
  }
}
