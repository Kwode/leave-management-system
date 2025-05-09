import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// StatusBadge widget for styled status display
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({required this.status, Key? key}) : super(key: key);

  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: getStatusColor().withOpacity(0.1),
        border: Border.all(color: getStatusColor()),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SelectableText(
        status,
        style: TextStyle(color: getStatusColor(), fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Main RecentRequestsCard Widget
class RecentRequestsCard extends StatelessWidget {
  const RecentRequestsCard({Key? key}) : super(key: key);

  String _formatDateRange(dynamic startRaw, dynamic endRaw) {
    DateTime? startDate;
    DateTime? endDate;

    if (startRaw is Timestamp) {
      startDate = startRaw.toDate();
    } else if (startRaw is String) {
      startDate = DateTime.tryParse(startRaw);
    }

    if (endRaw is Timestamp) {
      endDate = endRaw.toDate();
    } else if (endRaw is String) {
      endDate = DateTime.tryParse(endRaw);
    }

    final dateFormatter = DateFormat('MMM d');

    if (startDate != null && endDate != null) {
      if (startDate.year == endDate.year && startDate.month == endDate.month) {
        return '${dateFormatter.format(startDate)}–${DateFormat('d, y').format(endDate)}';
      } else {
        return '${DateFormat('MMM d, y').format(startDate)} – ${DateFormat('MMM d, y').format(endDate)}';
      }
    } else if (startDate != null) {
      return DateFormat('MMM d, y').format(startDate);
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent Leave Requests",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('leave_applications')
                        .where(
                          'userId',
                          isEqualTo: currentUserId,
                        ) // Filter by user
                        .orderBy(
                          'createdAt',
                          descending: true,
                        ) // Sort by creation date
                        .limit(5)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final leaveRequests = snapshot.data!.docs;

                  if (leaveRequests.isEmpty) {
                    return const Center(
                      child: Text(
                        'No recent leave requests',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: leaveRequests.length,
                    itemBuilder: (context, index) {
                      final data =
                          leaveRequests[index].data() as Map<String, dynamic>;
                      String leaveType = data['leaveType'] ?? 'N/A';
                      String dateRange = _formatDateRange(
                        data['startDate'],
                        data['endDate'],
                      );
                      String status = data['status'] ?? 'Unknown';

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 0,
                        ),
                        title: SelectableText(
                          leaveType,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: SelectableText(
                          dateRange,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: StatusBadge(status: status),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
