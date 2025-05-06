import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:leave_management_system/pages/admin/admin_home_page.dart';
import 'package:leave_management_system/pages/lecturer/home_page.dart';
import 'package:leave_management_system/pages/landing_page.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leave Management System',
      debugShowCheckedModeBanner: false,
      home: HomePageAdmin(),

      routes: {
        "signin": (context) => SignInPage(),
        "home": (context) => HomePage(),
        "signup": (context) => SignupPage(),
      },
    );
  }
}
