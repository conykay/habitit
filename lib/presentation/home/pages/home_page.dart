import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/presentation/habits/bloc/habit_state.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';
import 'package:habitit/presentation/home/bloc/mark_habit_complete_cubit.dart';

import '../widgets/home_table_calendar.dart';
import '../widgets/today_habits_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                  const GreetingTitleView(),
                  SizedBox(height: 15),
                  HomeTableCalendarWidget(),
                  SizedBox(height: 15),
                  const HabitsSectionTitle(),
                  SizedBox(height: 15),
                  const HabitsGridSectionView()
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ignore: must_be_immutable
class HabitsGridSectionView extends StatelessWidget {
  const HabitsGridSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<HabitEntity>? allHabits;

    return Expanded(
      child: BlocBuilder<HabitStateCubit, HabitState>(
        builder: (context, state) {
          var loading = state is HabitLoading;

          if (state is HabitError) return Center(child: Text(state.message));

          if (state is HabitLoaded) allHabits = state.habits;

          if (allHabits == null) {
            return Center(child: CircularProgressIndicator());
          }

          if (allHabits!.isEmpty) {
            return Center(child: Text('Create some habits to see them here'));
          }

          return Column(
            children: [
              if (loading) LinearProgressIndicator(),
              Expanded(child: TodayHabitsView(habits: allHabits!)),
            ],
          );
        },
      ),
    );
  }
}

class HabitsSectionTitle extends StatelessWidget {
  const HabitsSectionTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Today\'s Tasks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text('remaining'),
      ],
    );
  }
}

class GreetingTitleView extends StatelessWidget {
  const GreetingTitleView({
    super.key,
  });

  List<String> get _greeting {
    var hour = DateTime.now().hour;
    switch (hour) {
      case < 12:
        return ['Good Morning', 'Ready to tackle the day ?'];
      case < 17:
        return ['Afternoon', 'Don\'t forget to reward yourself'];
      default:
        return ['Evening', 'There\'s still time'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final [greeting, message] = _greeting;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Text(
          message,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
