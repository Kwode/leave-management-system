import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leave_management_system/pages/admin/admin_home_page.dart';
import 'package:leave_management_system/pages/lecturer/home_page.dart';
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<String?> _getUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['role'] as String?;
      }
      return null;
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // User not signed in, redirect to sign-in page or show a placeholder    
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'signin');
            },
            child: const Text('Go to Sign In'),
          ),
        ),
      );
    }

    return FutureBuilder<String?>(
      future: _getUserRole(currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            body: Center(
              child: Text(
                'Unable to determine user role.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final role = snapshot.data!.toLowerCase();

        if (role == 'admin') {
          return const HomePageAdmin();
        } else if (role == 'lecturer') {
          return const HomePage();
        } else {
          // If unknown role, show message or fallback UI
          return Scaffold(
            body: Center(
              child: Text(
                'Unknown role: $role',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }
      },
    );
  }
}