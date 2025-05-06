import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportsAnalyticsAdminPage extends StatelessWidget {
  const ReportsAnalyticsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports & Analytics"),
        backgroundColor: const Color.fromARGB(255, 0, 34, 61),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Report Overview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 34, 61),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Overview",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Total Leave Requests: 150\n"
                      "Average Leave Duration: 5 days\n"
                      "Active Users: 80\n"
                      "Pending Requests: 20",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
          
              const SizedBox(height: 20),
          
              // Leave Requests Trend Chart
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Leave Requests Trend (Last 6 Months)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 50,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const months = ["Nov", "Dec", "Jan", "Feb", "Mar", "Apr"];
                            if (value.toInt() >= 0 && value.toInt() < months.length) {
                              return Text(months[value.toInt()], style: const TextStyle(color: Colors.black));
                            }
                            return const Text("");
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(color: Colors.black),
                            );
                          },
                          interval: 10,
                          reservedSize: 32,
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      ),
                    ),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 20, color: Colors.blue, width: 16)]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 30, color: Colors.blue, width: 16)]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 25, color: Colors.blue, width: 16)]),
                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 40, color: Colors.blue, width: 16)]),
                      BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 35, color: Colors.blue, width: 16)]),
                      BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 28, color: Colors.blue, width: 16)]),
                    ],
                  ),
                ),
              ),
          
              const SizedBox(height: 30),
          
              // Leave Type Distribution Pie Chart
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Leave Type Distribution",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 40,
                    sections: [
                      PieChartSectionData(
                        color: Colors.blue,
                        value: 40,
                        title: 'Annual',
                        radius: 80,
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: Colors.orange,
                        value: 30,
                        title: 'Sick',
                        radius: 70,
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: Colors.red,
                        value: 20,
                        title: 'Maternity',
                        radius: 60,
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: Colors.green,
                        value: 10,
                        title: 'Study',
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          
              const SizedBox(height: 30),
          
              // Export Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement PDF export
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("Export PDF"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 34, 61),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement Excel export
                    },
                    icon: const Icon(Icons.grid_on),
                    label: const Text("Export Excel"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 34, 61),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}