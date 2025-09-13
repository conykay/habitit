import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habitit/common/habit/analytics_calculator.dart';
import 'package:habitit/domain/habits/entities/habit_entity.dart';

class AdherenceRatesWidget extends StatelessWidget {
  final List<HabitEntity> habits;

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
          height: 150,
          child: Expanded(
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var habit = habits[index];
                  var adherenceRate = calculateAdherenceRate(habit);
                  var color =
                      Color((math.Random().nextDouble() * 0xFFFFFF).toInt());

                  return _buildChartData(habit, adherenceRate, color);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 20);
                },
                itemCount: habits.length),
          ),
        ),
      ],
    );
  }

  SizedBox _buildChartData(
      HabitEntity habit, double adherenceRate, Color color) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            habit.name,
            overflow: TextOverflow.ellipsis,
          ),
          AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              duration: Duration(seconds: 1),
              PieChartData(
                centerSpaceRadius: 30,
                titleSunbeamLayout: true,
                startDegreeOffset: 10,
                sections: [
                  PieChartSectionData(
                      value: adherenceRate,
                      radius: 30,
                      showTitle: true,
                      title: '${adherenceRate.toStringAsFixed(0)}%',
                      titleStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      color: color.withValues(alpha: 0.6)),
                  PieChartSectionData(
                    value: 100 - adherenceRate,
                    radius: 25,
                    showTitle: false,
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
