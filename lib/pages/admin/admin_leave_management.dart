import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveManagementPage extends StatefulWidget {
  const LeaveManagementPage({super.key});

  @override
  _LeaveManagementPageState createState() => _LeaveManagementPageState();
}

class _LeaveManagementPageState extends State<LeaveManagementPage> {
  String? _filterStatus = 'All';
  String _searchQuery = '';
  List<Map<String, dynamic>> leaveRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeaveRequests();
  }
// Add at the top of your file

Future<void> _fetchLeaveRequests() async {
  setState(() {
    _isLoading = true;
  });

  final formatter = DateFormat('MMM d, yyyy'); // e.g. Jan 2, 2025

  String formatDate(dynamic value) {
    if (value is Timestamp) {
      return formatter.format(value.toDate());
    } else if (value is String) {
      DateTime? dt = DateTime.tryParse(value);
      return dt != null ? formatter.format(dt) : '';
    } else {
      return '';
    }
  }

  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('leave_applications').get();
    setState(() {
      leaveRequests = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'userId': data['userId'] ?? '',
          'leaveType': data['leaveType'] ?? '',
          'startDate': formatDate(data['startDate']),
          'endDate': formatDate(data['endDate']),
          'status': data['status'] ?? '',
        };
      }).toList();
    });
  } catch (e) {
    print("Error fetching leave requests: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to fetch leave requests')),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  Future<void> _updateLeaveStatus(String id, String status) async {
    try {
      await FirebaseFirestore.instance.collection('leave_applications').doc(id).update({'status': status});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Leave application $status')),
      );
      await _fetchLeaveRequests(); // Refresh the list after updating
    } catch (e) {
      print("Error updating leave status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update leave status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter leave requests based on search query and selected status
    List<Map<String, dynamic>> filteredRequests = leaveRequests.where((request) {
      final matchesSearch = request['userId'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _filterStatus == 'All' || request['status'] == _filterStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Management"),
        backgroundColor: const Color.fromARGB(255, 0, 34, 61),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search and Filter Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Search by Employee (User ID)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _filterStatus,
                  items: <String>['All', 'Pending', 'Approved', 'Rejected']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _filterStatus = newValue;
                    });
                  },
                  hint: const Text("Filter"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Loading indicator or message when no data
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (filteredRequests.isEmpty)
              const Center(child: Text('No leave requests found.'))
            else
              // Leave Requests Table
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Employee ID")),
                      DataColumn(label: Text("Leave Type")),
                      DataColumn(label: Text("Start Date")),
                      DataColumn(label: Text("End Date")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Actions")),
                    ],
                    rows: filteredRequests.map((request) {
                      return DataRow(cells: [
                        DataCell(Text(request['userId'])),
                        DataCell(Text(request['leaveType'])),
                        DataCell(Text(request['startDate'])),
                        DataCell(Text(request['endDate'])),
                        DataCell(Text(request['status'])),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: request['status'] == 'Pending'
                                  ? () => _updateLeaveStatus(request['id'], 'Approved')
                                  : null,
                              tooltip: 'Approve',
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: request['status'] == 'Pending'
                                  ? () => _updateLeaveStatus(request['id'], 'Rejected')
                                  : null,
                              tooltip: 'Reject',
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Summary Statistics
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 34, 61),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    "Leave Requests Summary",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Total Requests: ${leaveRequests.length}\n"
                    "Approved: ${leaveRequests.where((r) => r['status'] == 'Approved').length}\n"
                    "Pending: ${leaveRequests.where((r) => r['status'] == 'Pending').length}\n"
                    "Rejected: ${leaveRequests.where((r) => r['status'] == 'Rejected').length}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}