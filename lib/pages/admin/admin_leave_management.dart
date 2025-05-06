import 'package:flutter/material.dart';

class LeaveManagementPage extends StatelessWidget {
  const LeaveManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    decoration: InputDecoration(
                      labelText: "Search by Employee Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  items: <String>['All', 'Pending', 'Approved', 'Rejected']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},
                  hint: const Text("Filter"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Leave Requests Table
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Employee")),
                    DataColumn(label: Text("Leave Type")),
                    DataColumn(label: Text("Start Date")),
                    DataColumn(label: Text("End Date")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: List<DataRow>.generate(
                    10,
                    (index) => DataRow(cells: [
                      DataCell(Text("Employee ${index + 1}")),
                      DataCell(Text("Sick Leave")),
                      DataCell(Text("2023-10-01")),
                      DataCell(Text("2023-10-05")),
                      DataCell(Text("Pending")),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              // Approve action
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              // Reject action
                            },
                          ),
                        ],
                      )),
                    ]),
                  ),
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
                children: const [
                  Text(
                    "Leave Requests Summary",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Total Requests: 100\n"
                    "Approved: 70\n"
                    "Pending: 20\n"
                    "Rejected: 10",
                    style: TextStyle(color: Colors.white70),
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