import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/presentation/habits/bloc/habit_state.dart';

class HabitStateCubit extends Cubit<HabitState> {
  HabitStateCubit() : super(HabitInitial());

  void getHabits({required UseCase usecase}) async {
    emit(HabitLoading());
    Either habits = await usecase.call();
    habits.fold(
      (l) => emit(HabitError(message: l.toString())),
      (r) => emit(HabitLoaded(habits: r)),
    );
  }
}
