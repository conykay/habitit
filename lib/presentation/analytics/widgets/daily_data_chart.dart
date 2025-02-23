import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
    } else {
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
                      interval: maxX == 0 ? 1 : maxX,
                      getTitlesWidget: (value, meta) {
                        final date =
                            startDate.add(Duration(days: value.toInt()));
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
}
