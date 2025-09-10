import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/common/habit/analytics_calculator.dart';
import 'package:habitit/domain/habits/entities/habit_entity.dart';
import 'package:habitit/presentation/analytics/widgets/adherence_rates.dart';
import 'package:habitit/presentation/habits/bloc/habit_state.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';

import '../widgets/daily_data_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<HabitStateCubit>(),
      child: LayoutBuilder(builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<HabitStateCubit>().getHabits();
          },
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: BlocBuilder<HabitStateCubit, HabitState>(
                  builder: (context, state) {
                    switch (state) {
                      case HabitLoading():
                        final bool hasData =
                            context.read<HabitStateCubit>().hasData;
                        if (hasData && state.oldHabits != null) {
                          return _buildAnalytics(
                              allHabits: state.oldHabits!, loading: true);
                        }
                        return Center(child: CircularProgressIndicator());
                      case HabitLoaded():
                        return _buildAnalytics(allHabits: state.habits);
                      case HabitError():
                        return Center(
                          child: Text('Error retrieving data'),
                        );

                      default:
                        return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  SingleChildScrollView _buildAnalytics(
      {required List<HabitEntity> allHabits, bool loading = false}) {
    final highestStreak = longestStreakInAllHabits(allHabits);
    final dailyData = getDailyCompletionData(allHabits);

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: allHabits.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (loading) LinearProgressIndicator(),
                StreakBoxView(highestStreak: highestStreak),
                SizedBox(height: 15),
                AdherenceRatesWidget(habits: allHabits),
                SizedBox(height: 15),
                DailyDataLineChart(dailyData: dailyData)
              ],
            )
          : Center(
              child: Text('Add some habits to see your progress here'),
            ),
    );
  }
}

class StreakBoxView extends StatelessWidget {
  const StreakBoxView({
    super.key,
    required this.highestStreak,
  });

  final int highestStreak;

  @override
  Widget build(BuildContext context) {
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
                        fontSize: 24),
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
