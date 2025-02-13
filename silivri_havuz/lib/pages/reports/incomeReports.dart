import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../controller/app_state.dart';

class PageReportIncome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gelir Raporları',
            style: AppState.instance.themeData.textTheme.headlineLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Aylık Gelir Trendleri",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(1, 5000),
                        FlSpot(2, 7000),
                        FlSpot(3, 8000),
                        FlSpot(4, 6000),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
