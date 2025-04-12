import 'package:flutter/material.dart';

class NotificationsOrColleaguesCard extends StatelessWidget {
  const NotificationsOrColleaguesCard({super.key});

  final List<Map<String, String>> colleaguesOnLeave = const [
    {"name": "Jane Doe", "type": "Annual Leave", "date": "Apr 12–20"},
    {"name": "John Smith", "type": "Medical Leave", "date": "Apr 15–18"},
    {"name": "Mary Lee", "type": "Study Leave", "date": "Apr 10–12"},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      width: 1226,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Colleagues On Leave",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),

SizedBox(height: 2,),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    colleaguesOnLeave.take(3).map((colleague) {
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    colleague["name"]!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    colleague["type"]!,
                                    style: const TextStyle(fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    colleague["date"]!,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
