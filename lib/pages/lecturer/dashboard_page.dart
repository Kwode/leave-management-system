import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                          const Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 0, 34, 61),
                            size: 30,
                          ),
                          const SizedBox(width: 10),
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
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
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
            // StreamBuilder for dashboard stats
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('leave_applications')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final leaveRequests = snapshot.data!.docs;

                // Calculate stats
                int pendingApprovals =
                    leaveRequests
                        .where((doc) => doc['status'] == 'Pending')
                        .length;

                int leavesThisMonth =
                    leaveRequests.where((doc) {
                      final startDate =
                          (doc['startDate'] as Timestamp).toDate();
                      final today = DateTime.now();
                      return startDate.month == today.month &&
                          startDate.year == today.year;
                    }).length;

                // Replace with your actual leave balance logic
                int leaveBalance = 12;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDashboardCard(
                      "Leave Balance",
                      leaveBalance.toString(),
                      const Color.fromARGB(255, 1, 168, 151),
                    ),
                    _buildDashboardCard(
                      "Pending Approvals",
                      pendingApprovals.toString(),
                      const Color.fromARGB(255, 0, 101, 195),
                    ),
                    _buildDashboardCard(
                      "Leaves This Month",
                      leavesThisMonth.toString(),
                      const Color.fromARGB(255, 0, 51, 146),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                // Placeholder for recent requests card
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    ColoredBox(
                      color: Color.fromARGB(255, 93, 0, 97),
                      child: SizedBox(
                        height: 300,
                        width: 470,
                        child: Center(
                          child: Text(
                            'Recent Requests Card Placeholder',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 13),

                // Leave Summary Bar Chart streaming data dynamically
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 99, 31),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 300,
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('leave_applications')
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        final leaveRequests = snapshot.data!.docs;

                        return _buildBarChart(leaveRequests);
                      },
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
              width: double.infinity,
              child: const Center(
                child: Text(
                  'NotificationsOrColleaguesCard Placeholder',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 120,
      width: 400,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(List<QueryDocumentSnapshot> leaveRequests) {
    // Sample random monthly data: compute counts of leaves per month for the current year
    Map<int, int> leaveCounts = Map<int, int>.fromIterable(
      List.generate(12, (index) => index + 1),
      key: (item) => item as int,
      value: (item) => 0,
    );

    final currentYear = DateTime.now().year;

    for (var doc in leaveRequests) {
      try {
        final startDate = (doc['startDate'] as Timestamp).toDate();
        if (startDate.year == currentYear) {
          leaveCounts[startDate.month] = leaveCounts[startDate.month]! + 1;
        }
      } catch (e) {
        // ignore errors with malformed dates
      }
    }

    final maxY =
        (leaveCounts.values.isEmpty)
            ? 10.0
            : leaveCounts.values.reduce((a, b) => a > b ? a : b).toDouble() +
                2.0;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(enabled: true),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine:
              (value) =>
                  FlLine(color: Colors.white.withOpacity(0.2), strokeWidth: 1),
          getDrawingVerticalLine:
              (value) =>
                  FlLine(color: Colors.white.withOpacity(0.2), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                switch (value.toInt()) {
                  case 0:
                    return const Text(
                      'Jan',
                      style: TextStyle(color: Colors.white),
                    );
                  case 1:
                    return const Text(
                      'Feb',
                      style: TextStyle(color: Colors.white),
                    );
                  case 2:
                    return const Text(
                      'Mar',
                      style: TextStyle(color: Colors.white),
                    );
                  case 3:
                    return const Text(
                      'Apr',
                      style: TextStyle(color: Colors.white),
                    );
                  case 4:
                    return const Text(
                      'May',
                      style: TextStyle(color: Colors.white),
                    );
                  case 5:
                    return const Text(
                      'Jun',
                      style: TextStyle(color: Colors.white),
                    );
                  case 6:
                    return const Text(
                      'Jul',
                      style: TextStyle(color: Colors.white),
                    );
                  case 7:
                    return const Text(
                      'Aug',
                      style: TextStyle(color: Colors.white),
                    );
                  case 8:
                    return const Text(
                      'Sep',
                      style: TextStyle(color: Colors.white),
                    );
                  case 9:
                    return const Text(
                      'Oct',
                      style: TextStyle(color: Colors.white),
                    );
                  case 10:
                    return const Text(
                      'Nov',
                      style: TextStyle(color: Colors.white),
                    );
                  case 11:
                    return const Text(
                      'Dec',
                      style: TextStyle(color: Colors.white),
                    );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(12, (index) {
          final month = index + 1;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: leaveCounts[month]!.toDouble(),
                color: Colors.white,
                width: 18,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          );
        }),
      ),
    );
  }
}
