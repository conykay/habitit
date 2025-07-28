import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/presentation/habits/bloc/habit_state.dart';

import '../../../domain/habits/usecases/get_all_habits_usecase.dart';
import '../../../service_locator.dart';

class HabitStateCubit extends Cubit<HabitState> {
  HabitStateCubit() : super(HabitInitial());

  void getHabits() async {
    emit(HabitLoading());
    Either habits = await sl.get<GetAllHabitsUseCase>().call();
    habits.fold(
      (l) => emit(HabitError(message: l.toString())),
      (r) => emit(HabitLoaded(habits: r)),
    );
  }
}

//todo: convert to bloc using events
