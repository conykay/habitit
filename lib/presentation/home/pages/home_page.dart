import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';
import 'package:habitit/presentation/habits/bloc/habit_state.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';
import 'package:habitit/presentation/home/bloc/mark_habit_complete_cubit.dart';

import '../../../domain/habits/usecases/get_all_habits_usecase.dart';
import '../widgets/home_table_calendar.dart';
import '../widgets/today_habits_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: context.read<HabitStateCubit>()
            ..getHabits(
                usecase: GetAllHabitsUsecase(
                    repository: context.read<HabitRepository>())),
        ),
        BlocProvider(
          create: (context) =>
              MarkHabitCompleteCubit(context.read<HabitRepository>()),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _greetingTitle(),
            SizedBox(height: 15),
            HomeTableCalendarWidget(context: context),
            SizedBox(height: 15),
            _taskSectionTitle(),
            SizedBox(height: 15),
            Expanded(child: BlocBuilder<HabitStateCubit, HabitState>(
                builder: (context, state) {
              if (state is HabitLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is HabitLoaded) {
                if (state.habits.isEmpty) {
                  return Center(
                    child: Text('Create some habits to see them here'),
                  );
                }
                return TodayHabitsWidget(habits: state.habits);
              }
              if (state is HabitError) {
                return Center(
                  child: Text(state.message),
                );
              }
              return Container();
            }))
          ],
        ),
      ),
    );
  }

  Row _taskSectionTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Todays Tasks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text('remaining'),
      ],
    );
  }

  Column _greetingTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_greeting[0]},',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Text(
          _greeting[1],
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  List<String> get _greeting {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return ['Good Morning', 'Ready to tackle the day ?'];
    }
    if (hour < 17) {
      return ['Afternoon', 'Dont forget to reward yourself'];
    }

    return ['Evening', 'There\'s still time'];
  }
}
