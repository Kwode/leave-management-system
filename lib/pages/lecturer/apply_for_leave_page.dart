import 'package:flutter/material.dart';

class ApplyForLeavePage extends StatelessWidget {
  const ApplyForLeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Icon(Icons.notification_add, color: const Color.fromARGB(255, 0, 34, 61)),
              ],
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "Leave Application",
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leave Type Dropdown
              Text(
                "Leave Type",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                items: [
                  DropdownMenuItem(value: "Annual", child: Text("Annual Leave")),
                  DropdownMenuItem(value: "Sick", child: Text("Sick Leave")),
                  DropdownMenuItem(value: "Maternity", child: Text("Maternity Leave")),
                  DropdownMenuItem(value: "Study", child: Text("Study Leave")),
                ],
                onChanged: (value) {},
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Select Leave Type",
                ),
              ),

              SizedBox(height: 20),

              // Leave Duration
              Text(
                "Leave Duration",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Start Date (YYYY-MM-DD)",
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "End Date (YYYY-MM-DD)",
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Supporting Documents
              Text(
                "Supporting Documents (optional)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement file picker functionality here
                },
                child: Text("Upload Document"),
              ),

              SizedBox(height: 20),

              // Additional Comments
              Text(
                "Additional Comments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter any additional information here...",
                ),
              ),

              SizedBox(height: 30),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement submit functionality here
                  },
                  child: Text("Submit Application", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), backgroundColor: const Color.fromARGB(255, 0, 34, 61),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}