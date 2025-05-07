import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:leave_management_system/components/leave_type_breakdown.dart';
import 'package:leave_management_system/components/notifications_or_colleagues_card.dart';
import 'package:leave_management_system/components/status_badge.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    child: SizedBox(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: const Color.fromARGB(255, 0, 34, 61),
                            size: 30,
                          ),
                          const SizedBox(width: 10),
                          // Display the current user's email or 'Guest' if null
                          Text(
                            currentUser != null ? currentUser.email! : "Guest",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 34, 61),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: const Text(
            "Dashboard",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Color.fromARGB(255, 0, 34, 61),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            //dashboard containers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  height: 120,
                  width: 400,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 1, 168, 151),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const ListTile(
                    title: Text(
                      "Leave Balance",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "12",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  height: 120,
                  width: 400,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 101, 195),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const ListTile(
                    title: Text(
                      "Pending Approvals",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "5",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  height: 120,
                  width: 400,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 51, 146),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const ListTile(
                    title: Text(
                      "Leaves This Month",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "3",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    ColoredBox(
                      color: Color.fromARGB(255, 93, 0, 97),
                      child: SizedBox(
                        height: 300,
                        width: 470,
                        child: Center(child: Text('RecentRequestsCard Placeholder', style: TextStyle(color: Colors.white))),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 13),

                //others
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 99, 31),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 300,
                  width: 742,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Leave Summary",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 26,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Expanded(child: buildBarChart()),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 131, 61, 61),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 130,
              width: 1226,
              child: const Center(child: Text('NotificationsOrColleaguesCard Placeholder', style: TextStyle(color: Colors.white))),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        barTouchData: BarTouchData(enabled: true),

        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.white.withOpacity(0.2),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.white.withOpacity(0.2),
            strokeWidth: 1,
          ),
        ),

        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Jan', style: TextStyle(color: Colors.white));
                  case 1:
                    return const Text('Feb', style: TextStyle(color: Colors.white));
                  case 2:
                    return const Text('Mar', style: TextStyle(color: Colors.white));
                  case 3:
                    return const Text('Apr', style: TextStyle(color: Colors.white));
                  case 4:
                    return const Text('May', style: TextStyle(color: Colors.white));
                  case 5:
                    return const Text('Jun', style: TextStyle(color: Colors.white));
                  case 6:
                    return const Text('Jul', style: TextStyle(color: Colors.white));
                  case 7:
                    return const Text('Aug', style: TextStyle(color: Colors.white));
                  case 8:
                    return const Text('Sep', style: TextStyle(color: Colors.white));
                  case 9:
                    return const Text('Oct', style: TextStyle(color: Colors.white));
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        borderData: FlBorderData(show: false),

        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: 3,
                color: Colors.white,
                width: 18,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: 5,
                color: Colors.white,
                width: 18,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: 7,
                color: Colors.white,
                width: 18,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                toY: 3,
                color: Colors.white,
                width: 18,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ),
          BarChartGroupData(
            x: 4,
            barRods: [
              BarChartRodData(
                toY: 7,
                color: Colors.white,
                width: 18,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ),
          BarChartGroupData(
            x: 5,
            barRods: [
              BarChartRodData(
                toY: 9,
                color: Colors.white,
                width: 18,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ),
          BarChartGroupData(
            x: 6,
            barRods: [
              BarChartRodData(
                toY: 4,
                color: Colors.white,
                width: 18,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ),
          BarChartGroupData(
            x: 7,
            barRods: [
              BarChartRodData(
                toY: 3,
                color: Colors.white,
                width: 18,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ),
          BarChartGroupData(
            x: 8,
            barRods: [
              BarChartRodData(
                toY: 4,
                color: Colors.white,
                width: 18,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ),
          BarChartGroupData(
            x: 9,
            barRods: [
              BarChartRodData(
                toY: 7,
                color: Colors.white,
                width: 18,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}