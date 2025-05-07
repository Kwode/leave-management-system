import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
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
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('notifications')
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No notifications available.",
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              );
            }

            final notifications =
                snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return {
                    'title': data['title'] ?? '',
                    'description': data['description'] ?? '',
                    'date': data['date'] ?? '',
                    'read': data['read'] ?? false,
                  };
                }).toList();

            return ListView.separated(
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
            );
          },
        ),
      ),
    );
  }
}
