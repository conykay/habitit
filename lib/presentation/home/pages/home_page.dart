import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/presentation/habits/bloc/habit_state.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';
import 'package:habitit/presentation/home/bloc/mark_habit_complete_cubit.dart';

import '../widgets/home_table_calendar.dart';
import '../widgets/today_habits_grid.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<HabitEntity>? allHabits;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: context.read<HabitStateCubit>()..getHabits(),
        ),
        BlocProvider(
          create: (context) => MarkHabitCompleteCubit(),
        ),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),
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
                    var loading = state is HabitLoading;
                    if (state is HabitError) {
                      return Center(
                        child: Text(state.message),
                      );
                    }
                    if (state is HabitLoaded) {
                      allHabits = state.habits;
                    }
                    if (allHabits != null) {
                      if (allHabits!.isEmpty) {
                        return Center(
                          child: Text('Create some habits to see them here'),
                        );
                      }
                      return Column(
                        children: [
                          loading
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: LinearProgressIndicator(),
                                )
                              : SizedBox(),
                          Expanded(
                              child: TodayHabitsWidget(habits: allHabits!)),
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }))
                ],
              ),
            ),
          ),
        );
      }),
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
