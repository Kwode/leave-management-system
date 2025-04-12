import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:leave_management_system/components/dasboard_card.dart';

class LeaveTypeBreakdown extends StatelessWidget {
  const LeaveTypeBreakdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: "Leave Type Breakdown",
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 20, // Max value for bar chart
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return Text('Annual');
                    case 1:
                      return Text('Casual');
                    case 2:
                      return Text('Sick');
                    default:
                      return Text('');
                  }
                },
              ),
            ),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [BarChartRodData(toY: 8, color: Colors.teal, width: 20)],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(toY: 2, color: Colors.orange, width: 20),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [BarChartRodData(toY: 1, color: Colors.red, width: 20)],
            ),
          ],
        ),
      ),
    );
  }
}