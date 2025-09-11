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
          (dailyData.values.reduce((a, b) => a > b ? a : b)).toDouble() + 1;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Completion Data',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          AspectRatio(
              aspectRatio: 1.25,
              child: LineChart(
                duration: Duration(seconds: 2),
                LineChartData(
                  minX: 0,
                  maxX: maxX,
                  minY: 0,
                  maxY: maxY,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text(
                        'Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 25,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final date =
                              startDate.add(Duration(days: value.toInt()));
                          return SideTitleWidget(
                              meta: meta,
                              space: 10,
                              fitInside:
                                  SideTitleFitInsideData.fromTitleMeta(meta),
                              child: Text(
                                "${date.month}/${date.day}",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ));
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          interval: 1,
                          minIncluded: false,
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                              meta: meta,
                              space: 10,
                              fitInside:
                                  SideTitleFitInsideData.fromTitleMeta(meta),
                              child: Text(
                                '${value.toInt()}',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            );
                          }),
                      axisNameWidget: Text(
                        'Completion',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      axisNameSize: 25,
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      preventCurveOverShooting: false,
                      color: Colors.amber,
                      barWidth: 3,
                      dotData: FlDotData(),
                    ),
                  ],
                ),
              )),
        ],
      );
    }
  }
}
