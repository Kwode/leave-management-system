import 'package:flutter/material.dart';

class LeaveHistoryPage extends StatelessWidget {
  const LeaveHistoryPage({super.key});

  // Sample data for leave history
  final List<Map<String, String>> leaveHistory = const [
    {
      'leaveType': 'Annual Leave',
      'status': 'Approved',
      'duration': '2024-05-01 to 2024-05-05',
      'dateApplied': '2024-04-15',
    },
    {
      'leaveType': 'Sick Leave',
      'status': 'Pending',
      'duration': '2024-06-10 to 2024-06-12',
      'dateApplied': '2024-06-01',
    },
    {
      'leaveType': 'Study Leave',
      'status': 'Rejected',
      'duration': '2023-12-01 to 2023-12-15',
      'dateApplied': '2023-11-20',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "Leave History",
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
        child: leaveHistory.isEmpty
            ? Center(
                child: Text(
                  "No leave history available.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
              )
            : ListView.separated(
                itemCount: leaveHistory.length,
                separatorBuilder: (context, index) => SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final leave = leaveHistory[index];

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 230, 240, 245),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        // Leave Type Icon and Text
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color.fromARGB(255, 0, 34, 61),
                          child: Text(
                            leave['leaveType']![0], // First letter of leave type
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),

                        SizedBox(width: 20),

                        // Leave Details Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                leave['leaveType']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: const Color.fromARGB(255, 0, 34, 61),
                                ),
                              ),

                              SizedBox(height: 6),

                              Text(
                                "Duration: ${leave['duration']}",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                ),
                              ),

                              SizedBox(height: 4),

                              Text(
                                "Applied on: ${leave['dateApplied']}",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Leave Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _getStatusColor(leave['status']!).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            leave['status']!,
                            style: TextStyle(
                              color: _getStatusColor(leave['status']!),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}