import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../controller/app_state.dart';

class PageReportIncome extends StatelessWidget {
  const PageReportIncome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gelir Raporları', style: AppState.instance.themeData.textTheme.headlineLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Aylık Gelir Trendleri",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(1, 5000),
                        const FlSpot(2, 7000),
                        const FlSpot(3, 8000),
                        const FlSpot(4, 6000),
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
