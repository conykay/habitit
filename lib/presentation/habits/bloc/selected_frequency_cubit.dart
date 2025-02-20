import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/habits/models/habit_frequency.dart';

class SelectedFrequencyCubit extends Cubit<HabitFrequency> {
  SelectedFrequencyCubit() : super(HabitFrequency.daily);
  var selectedFequency = HabitFrequency.daily;
  void selectFrequency(HabitFrequency frequency) {
    selectedFequency = frequency;
    emit(frequency);
  }
}
