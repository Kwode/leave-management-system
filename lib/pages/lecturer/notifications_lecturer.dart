import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  final List<Map<String, dynamic>> notifications = const [
    {
      'title': 'Leave Application Approved',
      'description': 'Your leave request for May 1 - May 5 has been approved.',
      'date': '2024-04-20 10:30 AM',
      'read': true,
    },
    {
      'title': 'New Leave Request Pending',
      'description': 'You have 1 new leave approval request pending.',
      'date': '2024-04-22 09:00 AM',
      'read': false,
    },
    {
      'title': 'Password Change',
      'description': 'Your password was changed successfully on April 15.',
      'date': '2024-04-15 04:00 PM',
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "Notifications",
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
        child:
            notifications.isEmpty
                ? Center(
                  child: Text(
                    "No notifications available.",
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                )
                : ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    bool isRead = notification['read'] as bool;

                    return Container(
                      decoration: BoxDecoration(
                        color:
                            isRead
                                ? const Color.fromARGB(255, 230, 240, 245)
                                : const Color.fromARGB(255, 0, 34, 61),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification['title']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color:
                                  isRead
                                      ? const Color.fromARGB(255, 0, 34, 61)
                                      : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            notification['description']!,
                            style: TextStyle(
                              fontSize: 16,
                              color: isRead ? Colors.grey[800] : Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            notification['date']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: isRead ? Colors.grey[600] : Colors.white38,
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
