import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habitit/common/habit/analytics_calculator.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';

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
          height: 200,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var habit = habits[index];
                var adherenceRate = calculateAdherenceRate(habit);
                var color =
                    Color((math.Random().nextDouble() * 0xFFFFFF).toInt());

                return SizedBox(
                  width: 150,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        habit.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      AspectRatio(
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
                    ],
                  ),
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
