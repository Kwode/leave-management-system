import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:leave_management_system/components/notifications_or_colleagues_card.dart';
import 'package:leave_management_system/components/status_badge.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // Assumed leave quota per user per year for leave balance calculation
  static const int annualLeaveQuota = 30;

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

                int pendingApprovals = 0;
                int leavesThisMonth = 0;
                int usedAnnualLeaves = 0;

                final today = DateTime.now();
                final currentYear = today.year;
                final currentMonth = today.month;

                for (var doc in leaveRequests) {
                  try {
                    final data = doc.data() as Map<String, dynamic>;

                    if (doc['userId'] != currentUser?.uid) continue;

                    final status =
                        (data['status'] ?? '').toString().toLowerCase();

                    if (status == 'pending') pendingApprovals++;

                    DateTime? startDate;
                    DateTime? endDate;
                    final startDateRaw = data['startDate'];
                    final endDateRaw = data['endDate'];

                    if (startDateRaw is Timestamp)
                      startDate = startDateRaw.toDate();
                    else if (startDateRaw is String)
                      startDate = DateTime.tryParse(startDateRaw);

                    if (endDateRaw is Timestamp)
                      endDate = endDateRaw.toDate();
                    else if (endDateRaw is String)
                      endDate = DateTime.tryParse(endDateRaw);

                    if (startDate != null && endDate != null) {
                      if (startDate.year == currentYear &&
                          startDate.month == currentMonth)
                        leavesThisMonth++;

                      final leaveType =
                          (data['leaveType'] ?? '').toString().toLowerCase();
                      if (leaveType == 'annual' && status == 'approved') {
                        final duration =
                            endDate.difference(startDate).inDays + 1;
                        usedAnnualLeaves += duration;
                      }
                    }
                  } catch (_) {
                    continue;
                  }
                }

                int leaveBalance = (annualLeaveQuota - usedAnnualLeaves).clamp(
                  0,
                  annualLeaveQuota,
                );

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDashboardCard(
                      'Leave Balance',
                      leaveBalance.toString(),
                      const Color.fromARGB(255, 1, 168, 151),
                    ),
                    _buildDashboardCard(
                      'Pending Approvals',
                      pendingApprovals.toString(),
                      const Color.fromARGB(255, 0, 101, 195),
                    ),
                    _buildDashboardCard(
                      'Leaves This Month',
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
                Expanded(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        SizedBox(
                          height: 300,
                          child: ColoredBox(
                            color: Color.fromARGB(255, 93, 0, 97),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: RecentRequestsCard(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 13),

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
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        if (snapshot.hasError)
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );

                        final leaveRequests = snapshot.data!.docs;

                        return _buildBarChart(leaveRequests, currentUser?.uid);
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Container(
              color: const Color.fromARGB(255, 131, 61, 61),
              child: const NotificationsOrColleaguesCard(),
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

  Widget _buildBarChart(
    List<QueryDocumentSnapshot> leaveRequests,
    String? userId,
  ) {
    Map<int, int> monthlyCounts = Map.fromIterable(
      List.generate(12, (index) => index + 1),
      key: (item) => item as int,
      value: (item) => 0,
    );

    final currentYear = DateTime.now().year;

    for (final doc in leaveRequests) {
      try {
        final data = doc.data() as Map<String, dynamic>;
        if (data['userId'] != userId) continue;

        DateTime? startDate;
        final rawStart = data['startDate'];

        if (rawStart is Timestamp)
          startDate = rawStart.toDate();
        else if (rawStart is String)
          startDate = DateTime.tryParse(rawStart);

        if (startDate != null && startDate.year == currentYear) {
          monthlyCounts[startDate.month] = monthlyCounts[startDate.month]! + 1;
        }
      } catch (_) {
        continue;
      }
    }

    final maxY =
        monthlyCounts.values.isEmpty
            ? 10.0
            : monthlyCounts.values.reduce((a, b) => a > b ? a : b).toDouble() +
                2;

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
                const months = [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'May',
                  'Jun',
                  'Jul',
                  'Aug',
                  'Sep',
                  'Oct',
                  'Nov',
                  'Dec',
                ];
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return Text(
                    months[value.toInt()],
                    style: const TextStyle(color: Colors.white),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget:
                  (value, _) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
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
                toY: monthlyCounts[month]!.toDouble(),
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
