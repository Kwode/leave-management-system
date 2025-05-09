import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardAdminPage extends StatelessWidget {
  const DashboardAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 247, 250),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "Admin Dashboard Overview",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: const Color.fromARGB(255, 0, 34, 61),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Key statistics cards row
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

                  int totalLeaveRequests = leaveRequests.length;
                  int pendingApprovals =
                      leaveRequests
                          .where(
                            (doc) =>
                                (doc['status'] ?? '')
                                    .toString()
                                    .toLowerCase() ==
                                'pending',
                          )
                          .length;
                  int activeStaffOnLeave =
                      leaveRequests
                          .where(
                            (doc) =>
                                (doc['status'] ?? '')
                                    .toString()
                                    .toLowerCase() ==
                                'approved',
                          )
                          .length;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard(
                        title: "Total Leave Requests",
                        value: totalLeaveRequests.toString(),
                        color: Colors.indigo,
                      ),
                      _buildStatCard(
                        title: "Pending Approvals",
                        value: pendingApprovals.toString(),
                        color: const Color.fromARGB(255, 235, 115, 63),
                      ),
                      _buildStatCard(
                        title: "Active Staff on Leave",
                        value: activeStaffOnLeave.toString(),
                        color: const Color.fromARGB(255, 0, 168, 151),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              // Leave trends bar chart container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 34, 61),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Leave Requests Trend (Last 6 Months)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 250,
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

                          // Initialize leave counts for the last 6 months
                          List<int> leaveCounts = List.filled(6, 0);
                          DateTime now = DateTime.now();

                          for (var doc in leaveRequests) {
                            try {
                              final data = doc.data() as Map<String, dynamic>;
                              DateTime? startDate;
                              if (data['startDate'] is Timestamp) {
                                startDate =
                                    (data['startDate'] as Timestamp).toDate();
                              } else if (data['startDate'] is String) {
                                startDate = DateTime.tryParse(
                                  data['startDate'],
                                );
                              }

                              if (startDate != null) {
                                final diffMonths =
                                    (now.year - startDate.year) * 12 +
                                    (now.month - startDate.month);
                                if (diffMonths >= 0 && diffMonths < 6) {
                                  // index 0 is current month, 5 is 5 months ago, reverse to show oldest first
                                  int index = 5 - diffMonths;
                                  leaveCounts[index] = leaveCounts[index] + 1;
                                }
                              }
                            } catch (_) {
                              // ignore malformed data
                            }
                          }

                          final maxY =
                              leaveCounts
                                  .reduce((a, b) => a > b ? a : b)
                                  .toDouble() +
                              5;

                          const months = [
                            "Nov",
                            "Dec",
                            "Jan",
                            "Feb",
                            "Mar",
                            "Apr",
                          ];

                          return BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: maxY,
                              barTouchData: BarTouchData(enabled: true),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final i = value.toInt();
                                      if (i >= 0 && i < months.length) {
                                        return Text(
                                          months[i],
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      );
                                    },
                                    interval: 10,
                                    reservedSize: 32,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                getDrawingHorizontalLine:
                                    (value) => FlLine(
                                      color: Colors.white24,
                                      strokeWidth: 1,
                                    ),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: List.generate(months.length, (i) {
                                return BarChartGroupData(
                                  x: i,
                                  barRods: [
                                    BarChartRodData(
                                      toY: leaveCounts[i].toDouble(),
                                      color: Colors.white,
                                      width: 16,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Alerts / Notifications summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 235, 115, 63),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Important Alerts",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "• 5 leave applications pending urgent approval.\n"
                      "• Department X coverage below threshold next week.\n"
                      "• Password resets required for 3 users.",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            offset: const Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
