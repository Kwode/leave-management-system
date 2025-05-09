import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsOrColleaguesCard extends StatelessWidget {
  const NotificationsOrColleaguesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Colleagues On Leave",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('leave_applications')
                        .where('status', isEqualTo: 'Approved')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child: Text(
                        'No data',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final leaveData = snapshot.data!.docs;

                  if (leaveData.isEmpty) {
                    return const Center(
                      child: Text(
                        'No colleagues on leave currently',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  // Limit to 3 colleagues as in your design
                  final displayData = leaveData.take(3).toList();

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        displayData.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final name =
                              data['userName'] ??
                              'Unknown'; // Adjust field as per your Firestore schema
                          final type = data['leaveType'] ?? 'Unknown';
                          final startDate = data['startDate'];
                          final endDate = data['endDate'];
                          final dateRange = _formatDateRange(
                            startDate,
                            endDate,
                          );

                          return Container(
                            width: 380,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Colors.teal,
                                  size: 32,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        type,
                                        style: const TextStyle(fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        dateRange,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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

    if (startDate == null) {
      return 'N/A';
    }

    final dateFormatter = DateFormat('MMM d');

    if (endDate == null || startDate == endDate) {
      return dateFormatter.format(startDate);
    }

    if (startDate.year == endDate.year && startDate.month == endDate.month) {
      // Same month and year
      return '${dateFormatter.format(startDate)}–${DateFormat('d, y').format(endDate)}';
    } else {
      // Different month/year
      return '${DateFormat('MMM d, y').format(startDate)} – ${DateFormat('MMM d, y').format(endDate)}';
    }
  }
}
