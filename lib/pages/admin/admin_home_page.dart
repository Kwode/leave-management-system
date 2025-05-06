import 'package:flutter/material.dart';
import 'package:leave_management_system/pages/admin/admin_calendar.dart';
import 'package:leave_management_system/pages/admin/admin_dashboard.dart';
import 'package:leave_management_system/pages/admin/admin_leave_management.dart';
import 'package:leave_management_system/pages/admin/admin_notification.dart';
import 'package:leave_management_system/pages/admin/admin_reports.dart';
import 'package:leave_management_system/pages/admin/admin_user_management.dart';


class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  int _selectedPageIndex = 0;

  final List<Widget> _pages = [
    DashboardAdminPage(),
    LeaveManagementPage(),
    UserManagementPage(),
    NotificationsAdminPage(),
    ReportsAnalyticsAdminPage(),
    CalendarAdminPage(),
  ];

  void _onTileTap(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Widget _buildSidebarTile({
    required int index,
    required IconData icon,
    required String title,
  }) {
    final bool isSelected = _selectedPageIndex == index;
    return ListTile(
      tileColor: isSelected ? Colors.black : null,
      leading: Icon(
        icon,
        color: const Color.fromARGB(255, 240, 240, 240),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Color.fromARGB(255, 240, 240, 240)),
      ),
      onTap: () => _onTileTap(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: const Color.fromARGB(255, 0, 34, 61),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 12, right: 12),
                  child: Column(
                    children: [
                      _buildSidebarTile(index: 0, icon: Icons.dashboard, title: "Dashboard"),
                      SizedBox(height: 10),
                      _buildSidebarTile(index: 1, icon: Icons.insert_drive_file, title: "Leave Management"),
                      SizedBox(height: 10),
                      _buildSidebarTile(index: 2, icon: Icons.group, title: "User Management"),
                      SizedBox(height: 10),
                      _buildSidebarTile(index: 3, icon: Icons.notifications, title: "Notifications"),
                      SizedBox(height: 10),
                      _buildSidebarTile(index: 4, icon: Icons.bar_chart, title: "Reports & Analytics"),
                      SizedBox(height: 10),
                      _buildSidebarTile(index: 5, icon: Icons.calendar_month_outlined, title: "Calendar"),
                      SizedBox(height: 300),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, "signin");
                        },
                        leading: const Icon(
                          Icons.logout,
                          color: Color.fromARGB(255, 240, 240, 240),
                        ),
                        title: const Text(
                          "Logout",
                          style: TextStyle(color: Color.fromARGB(255, 240, 240, 240)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main content area
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _pages[_selectedPageIndex],
            ),
          ),
        ],
      ),
    );
  }
}
