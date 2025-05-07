import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplyForLeavePage extends StatefulWidget {
  const ApplyForLeavePage({super.key});

  @override
  _ApplyForLeavePageState createState() => _ApplyForLeavePageState();
}

class _ApplyForLeavePageState extends State<ApplyForLeavePage> {
  final _formKey = GlobalKey<FormState>();
  String? _leaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  String _comments = '';
  String? _documentUrl; // Placeholder for document URL
  bool _isSubmitting = false; // Track submission state
  bool _isSubmitted = false; // Track if the application has been submitted

  Future<void> _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true; // Set submitting state
        _isSubmitted = false;
      });

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be signed in to apply for leave.')),
        );
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      final leaveApplication = {
        'userId': user.uid,
        'leaveType': _leaveType,
        'startDate': _startDate?.toIso8601String(),
        'endDate': _endDate?.toIso8601String(),
        'comments': _comments,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      try {
        await FirebaseFirestore.instance.collection('leave_applications').add(leaveApplication);
        setState(() {
          _isSubmitting = false; // Reset submitting state
          _isSubmitted = true; // Mark as submitted
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Leave application submitted successfully!')),
        );
      } catch (e) {
        print('Error submitting application: $e');
        setState(() {
          _isSubmitting = false; // Reset submitting state
          _isSubmitted = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit application.')),
        );
      }
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        // If end date is before start date, reset it
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime initialDate = _endDate ?? (_startDate ?? DateTime.now());
    final DateTime firstDate = _startDate ?? DateTime(2000);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    String buttonText;
    if (_isSubmitting) {
      buttonText = "Submitting...";
    } else if (_isSubmitted) {
      buttonText = "Submitted";
    } else {
      buttonText = "Submit Application";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: const [
                Icon(Icons.notification_add, color: Color.fromARGB(255, 0, 34, 61)),
              ],
            ),
          ),
        ],
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "Leave Application",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Color.fromARGB(255, 0, 34, 61),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Leave Type Dropdown
                const Text(
                  "Leave Type",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButtonFormField<String>(
                  value: _leaveType,
                  items: const [
                    DropdownMenuItem(value: "Annual", child: Text("Annual Leave")),
                    DropdownMenuItem(value: "Sick", child: Text("Sick Leave")),
                    DropdownMenuItem(value: "Maternity", child: Text("Maternity Leave")),
                    DropdownMenuItem(value: "Study", child: Text("Study Leave")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _leaveType = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select Leave Type",
                  ),
                  validator: (value) => value == null ? 'Please select a leave type' : null,
                ),

                const SizedBox(height: 20),

                // Leave Duration
                const Text(
                  "Leave Duration",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectStartDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Start Date",
                          ),
                          child: Text(
                            _formatDate(_startDate),
                            style: TextStyle(
                              fontSize: 16,
                              color: _startDate == null ? Colors.grey[600] : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: _startDate == null ? null : () => _selectEndDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "End Date",
                          ),
                          child: Text(
                            _formatDate(_endDate),
                            style: TextStyle(
                              fontSize: 16,
                              color: _endDate == null ? Colors.grey[600] : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if ((_startDate != null && _endDate != null) && _endDate!.isBefore(_startDate!))
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'End date cannot be before start date',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                const SizedBox(height: 20),

                // Supporting Documents
                const Text(
                  "Supporting Documents (optional)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement file picker functionality here
                  },
                  child: const Text("Upload Document"),
                ),

                const SizedBox(height: 20),

                // Additional Comments
                const Text(
                  "Additional Comments",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter any additional information here...",
                  ),
                  onChanged: (value) => _comments = value,
                ),

                const SizedBox(height: 30),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: (_isSubmitting || _isSubmitted)
                        ? null
                        : () {
                            if (_startDate == null || _endDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please select start and end dates')),
                              );
                              return;
                            }
                            if (_endDate!.isBefore(_startDate!)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('End date cannot be before start date')),
                              );
                              return;
                            }
                            _submitApplication();
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      child: Text(
                        buttonText,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (_isSubmitting || _isSubmitted)
                          ? Colors.grey
                          : const Color.fromARGB(255, 0, 34, 61),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}