import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:leave_management_system/components/leave_type_breakdown.dart';
import 'package:leave_management_system/components/notifications_or_colleagues_card.dart';
import 'package:leave_management_system/components/status_badge.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
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

                          SizedBox(width: 10),

                          Text(
                            "John Doe",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 34, 61),
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
          child: Text(
            "Dashboard",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: const Color.fromARGB(255, 0, 34, 61),
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
                  padding: EdgeInsets.all(8),
                  height: 120,
                  width: 400,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 1, 168, 151),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
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
                  padding: EdgeInsets.all(8),
                  height: 120,
                  width: 400,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 101, 195),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
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
                  padding: EdgeInsets.all(8),
                  height: 120,
                  width: 400,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 51, 146),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
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

            SizedBox(height: 30),

            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 93, 0, 97),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 300,
                      width: 470,
                      child: RecentRequestsCard(),
                    ),
                  ],
                ),

                SizedBox(width: 13),

                //others
                Container(
                  padding: EdgeInsets.all(8),
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
                        Text(
                          "Leave Summary",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 26,
                          ),
                        ),

                        SizedBox(height: 20,),

                        Expanded(child: buildBarChart()),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 131, 61, 61),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 130,
              width: 1226,
              child: NotificationsOrColleaguesCard(),
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

        // 🎯 Grid Lines Customization
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine:
              (value) => FlLine(
                color: Colors.white.withOpacity(
                  0.2,
                ), // light white horizontal grid lines
                strokeWidth: 1,
              ),
          getDrawingVerticalLine:
              (value) => FlLine(
                color: Colors.white.withOpacity(
                  0.2,
                ), // light white vertical grid lines
                strokeWidth: 1,
              ),
        ),

        // 🔢 Axis Titles Customization
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                switch (value.toInt()) {
                  case 0:
                    return Text('Jan', style: TextStyle(color: Colors.white));
                  case 1:
                    return Text('Feb', style: TextStyle(color: Colors.white));
                  case 2:
                    return Text('Mar', style: TextStyle(color: Colors.white));
                  case 3:
                    return Text('Apr', style: TextStyle(color: Colors.white));
                  case 4:
                    return Text('May', style: TextStyle(color: Colors.white));
                  case 5:
                    return Text('Jun', style: TextStyle(color: Colors.white));
                  case 6:
                    return Text('Jul', style: TextStyle(color: Colors.white));
                  case 7:
                    return Text('Aug', style: TextStyle(color: Colors.white));
                  case 8:
                    return Text('Sep', style: TextStyle(color: Colors.white));
                  case 9:
                    return Text('Oct', style: TextStyle(color: Colors.white));
                  default:
                    return Text('');
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
                  style: TextStyle(
                    color: Colors.white,
                  ), // 💡 white left axis numbers
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        borderData: FlBorderData(show: false),

        // 📊 Bar Data
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
