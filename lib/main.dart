import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:leave_management_system/pages/admin/admin_home_page.dart';
import 'package:leave_management_system/pages/lecturer/home_page.dart';
import 'package:leave_management_system/pages/sign_in_page.dart';
import 'package:leave_management_system/pages/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAl1cqg_cRFYPUWvCkr08WL5RVI_IH-cyQ",
        authDomain: "leave-managent-system.firebaseapp.com",
        projectId: "leave-managent-system",
        storageBucket: "leave-managent-system.firebasestorage.app",
        messagingSenderId: "460464719533",
        appId: "1:460464719533:web:4561d7fedf0f40cd3ce824",
      ),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String?> _getUserRole(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        return data?['role'] as String?;
      }
    } catch (e) {
      print("Failed to get user role: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leave Management System',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show loading while waiting for auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final user = snapshot.data;

          // If user not signed in, show sign in page
          if (user == null) {
            return const SignInPage();
          }

          // If user signed in, fetch role and navigate accordingly
          return FutureBuilder<String?>(
            future: _getUserRole(user.uid),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (roleSnapshot.hasError || !roleSnapshot.hasData || roleSnapshot.data == null) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      'Failed to get user role.\nPlease contact support.',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final role = roleSnapshot.data!.toLowerCase();

              if (role == 'admin') {
                return const HomePageAdmin();
              } else if (role == 'lecturer') {
                return const HomePage();
              } else {
                return Scaffold(
                  body: Center(
                    child: Text(
                      'Unrecognized role: $role',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
      routes: {
        "signin": (context) => const SignInPage(),
        "signup": (context) => const SignupPage(),
      },
    );
  }
}