// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:habitit/common/habit/analytics_calculator.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/presentation/habits/bloc/habit_state.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<HabitStateCubit>()..getHabits(),
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

class DailyDataLineChart extends StatelessWidget {
  const DailyDataLineChart({
    super.key,
    required this.dailyData,
  });

  final Map<DateTime, int> dailyData;

  @override
  Widget build(BuildContext context) {
    final sortedDates = dailyData.keys.toList()..sort();
    if (sortedDates.isEmpty) {
      return Center(
        child: Text('No data to display'),
      );
    }
    final startDate = sortedDates.first;
    final spots = sortedDates.map((data) {
      final x = data.difference(startDate).inDays.toDouble();
      final y = dailyData[data]!.toDouble();
      return FlSpot(x, y);
    }).toList();
    final maxX = sortedDates.last.difference(startDate).inDays.toDouble();
    final maxY =
        (dailyData.values.reduce((a, b) => a > b ? b : a)).toDouble() + 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Completion Data',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(LineChartData(
              minX: 0,
              maxX: maxX,
              minY: 0,
              maxY: maxY,
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: maxX,
                    getTitlesWidget: (value, meta) {
                      final date = startDate.add(Duration(days: value.toInt()));
                      return Text("${date.month}/${date.day}",
                          style: TextStyle(fontSize: 10));
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 1),
                ),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  color: Colors.amber,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
              ],
            )))
      ],
    );
  }
}

class AdherenceRatesWidget extends StatelessWidget {
  final List<HabitEnity> habits;
  const AdherenceRatesWidget({
    super.key,
    required this.habits,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adherence Rates',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var habit = habits[index];
                var adherenceRate = calculateAdherenceRate(habit);
                var color =
                    Color((math.Random().nextDouble() * 0xFFFFFF).toInt());

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      habit.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 150,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          duration: Duration(milliseconds: 150),
                          curve: Curves.linear,
                          PieChartData(centerSpaceRadius: 40, sections: [
                            PieChartSectionData(
                                value: adherenceRate,
                                showTitle: false,
                                badgeWidget: Text(
                                  '${adherenceRate.toStringAsFixed(1)} %',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                color: color.withValues(alpha: 0.6)),
                            PieChartSectionData(
                              value: 100 - adherenceRate,
                              showTitle: false,
                              color: Colors.grey.withValues(alpha: 0.3),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(width: 20);
              },
              itemCount: habits.length),
        ),
      ],
    );
  }
}
