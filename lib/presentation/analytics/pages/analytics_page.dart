// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/common/habit/analytics_calculator.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';
import 'package:habitit/presentation/analytics/widgets/adherence_rates.dart';
import 'package:habitit/presentation/habits/bloc/habit_state.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';

import '../../../domain/habits/usecases/get_all_habits_usecase.dart';
import '../widgets/daily_data_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<HabitStateCubit>()
        ..getHabits(
            usecase: GetAllHabitsUsecase(
                repository: context.read<HabitRepository>())),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: BlocBuilder<HabitStateCubit, HabitState>(
          builder: (context, state) {
            if (state is HabitLoaded) {
              if (state.habits.isNotEmpty) {
                var highestStreak = longestStreakInAllHabits(state.habits);
                var dailyData = getDailyCompletionData(state.habits);
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _streakBox(context, highestStreak),
                      SizedBox(height: 15),
                      AdherenceRatesWidget(habits: state.habits),
                      SizedBox(height: 15),
                      DailyDataLineChart(dailyData: dailyData)
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text('Create some habits to track your progress'),
                );
              }
            }
            if (state is HabitError) {
              return Center(
                child: Text('There was an error'),
              );
            }
            if (state is HabitLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Container();
          },
        ),
      ),
    );
  }

  Container _streakBox(BuildContext context, int highestStreak) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Highest Streak',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$highestStreak days',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Your Longest Ever Streak',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
          Expanded(
              child: FaIcon(
            FontAwesomeIcons.boltLightning,
            size: 80,
            color: Theme.of(context).colorScheme.secondary,
          )),
        ],
      ),
    );
  }
}
