import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/domain/habits/entities/habit_entity.dart';
import 'package:habitit/presentation/habits/bloc/habit_state.dart';

import '../../../domain/habits/usecases/get_all_habits_usecase.dart';
import '../../../service_locator.dart';

class HabitStateCubit extends Cubit<HabitState> {
  HabitStateCubit() : super(HabitInitial()) {
    getHabits();
  }

  List<HabitEntity> _oldHabits = [];

  void getHabits() async {
    emit(HabitLoading(oldHabits: _oldHabits));
    Either habits = await sl.get<GetAllHabitsUseCase>().call();
    habits.fold((l) => emit(HabitError(message: l.toString())), (r) {
      _oldHabits = r;
      emit(HabitLoaded(habits: r));
    });
  }

  bool get hasData => _oldHabits.isNotEmpty;

  List<HabitEntity> get oldHabits => _oldHabits;
}

//todo: return unmodifiable list
