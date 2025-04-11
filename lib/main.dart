import 'package:flutter/material.dart';
import 'package:leave_management_system/home_page.dart';
import 'package:leave_management_system/pages/landing_page.dart';
import 'package:leave_management_system/pages/sign_in_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leave Management System',
      debugShowCheckedModeBanner: false,
      home: LandingPage(),

      routes: {
        "signin": (context) => SignInPage(),
        "home": (context) => HomePage(),
      },
    );
  }
}

