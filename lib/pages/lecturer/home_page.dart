import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leave_management_system/pages/lecturer/apply_for_leave_page.dart';
import 'package:leave_management_system/pages/lecturer/dashboard_page.dart';
import 'package:leave_management_system/pages/lecturer/leave_history.dart';
import 'package:leave_management_system/pages/lecturer/lecturer-calendar.dart';
import 'package:leave_management_system/pages/lecturer/lecturer_reports';
import 'package:leave_management_system/pages/lecturer/notifications_lecturer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPageIndex = 0; // Default page is Home

  // List of pages
  final List<Widget> _pages = [
    DashboardPage(),
    ApplyForLeavePage(),
    LeaveHistoryPage(),
    NotificationsPage(),
    ReportsAnalyticsPage(),
    CalendarPage(),
  ];

  void _onTileTap(int index) {
    setState(() {
      _selectedPageIndex = index; // Update the displayed page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Drawer-Like Sidebar with ListTiles
          Container(
            width: 250,
            color: const Color.fromARGB(255, 0, 34, 61),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    left: 12,
                    right: 12,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        tileColor: Colors.black,
                        leading: Icon(
                          Icons.dashboard,
                          color: const Color.fromARGB(255, 240, 240, 240),
                        ),
                        title: Text(
                          "Dashboard",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 240, 240, 240),
                          ),
                        ),
                        onTap: () => _onTileTap(0),
                      ),

                      SizedBox(height: 10),

                      ListTile(
                        selectedTileColor: Colors.black,
                        leading: Icon(
                          Icons.insert_drive_file,
                          color: const Color.fromARGB(255, 240, 240, 240),
                        ),
                        title: Text(
                          "Apply For Leave",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 240, 240, 240),
                          ),
                        ),
                        onTap: () => _onTileTap(1),
                      ),

                      SizedBox(height: 10),

                      ListTile(
                        leading: Icon(
                          Icons.history,
                          color: const Color.fromARGB(255, 240, 240, 240),
                        ),
                        title: Text(
                          "Leave History",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 240, 240, 240),
                          ),
                        ),
                        onTap: () => _onTileTap(2),
                      ),

                      SizedBox(height: 10),

                      ListTile(
                        leading: Icon(
                          Icons.notifications,
                          color: const Color.fromARGB(255, 240, 240, 240),
                        ),
                        title: Text(
                          "Notifications",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 240, 240, 240),
                          ),
                        ),
                        onTap: () => _onTileTap(3),
                      ),

                      SizedBox(height: 10),

                      ListTile(
                        leading: Icon(
                          Icons.bar_chart,
                          color: const Color.fromARGB(255, 240, 240, 240),
                        ),
                        title: Text(
                          "Reports & Analytics",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 240, 240, 240),
                          ),
                        ),
                        onTap: () => _onTileTap(4),
                      ),

                      SizedBox(height: 10),

                      ListTile(
                        leading: Icon(
                          Icons.calendar_month_outlined,
                          color: const Color.fromARGB(255, 240, 240, 240),
                        ),
                        title: Text(
                          "Calendar",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 240, 240, 240),
                          ),
                        ),
                        onTap: () => _onTileTap(5),
                      ),

                      SizedBox(height: 300),

                      ListTile(
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushNamed(context, "signin");
                        },
                        leading: Icon(
                          Icons.logout,
                          color: const Color.fromARGB(255, 240, 240, 240),
                        ),
                        title: Text(
                          "Logout",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 240, 240, 240),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area (Dynamic Page Display)
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _pages[_selectedPageIndex], // Show selected page
            ),
          ),
        ],
      ),
    );
  }
}
