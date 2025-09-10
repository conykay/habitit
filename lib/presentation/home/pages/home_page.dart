import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/presentation/habits/bloc/habit_state.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';
import 'package:habitit/presentation/home/bloc/mark_habit_complete_cubit.dart';

import '../../../domain/habits/entities/habit_entity.dart';
import '../widgets/home_table_calendar.dart';
import '../widgets/today_habits_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: context.read<HabitStateCubit>(),
        ),
        BlocProvider(
          create: (context) => MarkHabitCompleteCubit(),
        ),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<HabitStateCubit>().getHabits();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 700,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
    return BlocBuilder<HabitStateCubit, HabitState>(
      builder: (context, state) {
        switch (state) {
          case HabitLoading():
            final bool hasData = context.read<HabitStateCubit>().hasData;
            if (hasData && state.oldHabits != null) {
              return _buildTodayHabitsView(
                  allHabits: state.oldHabits!, loading: true);
            }
            return Center(child: CircularProgressIndicator());
          case HabitLoaded():
            return _buildTodayHabitsView(allHabits: state.habits);
          case HabitError():
            return Center(child: Text(state.message));
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  Column _buildTodayHabitsView({
    required List<HabitEntity> allHabits,
    bool loading = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading) LinearProgressIndicator(),
        allHabits.isNotEmpty
            ? TodayHabitsView(habits: allHabits)
            : Center(child: Text('You haven\'t set any goals yet')),
      ],
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
