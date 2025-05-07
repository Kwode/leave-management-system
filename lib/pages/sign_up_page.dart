import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String selectedRole = 'Lecturer'; // Default role
  String errorMessage = "";
  bool isLoading = false;

  Future<void> signup(
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (password != confirmPassword) {
      setState(() {
        errorMessage = "Passwords do not match";
      });
      return;
    }

    if (!EmailValidator.validate(email)) {
      setState(() {
        errorMessage = "Invalid email format";
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        errorMessage = "Password must be at least 6 characters long";
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
        errorMessage = "";
      });

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid; // Get user ID

      // Store user role in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email,
        'role': selectedRole,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print("Signed Up successfully: $uid");
      // Clear input fields
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      Navigator.pushNamed(
        context,
        "signin",
      ); // Navigate to sign-in page after success
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "An error occurred";
      });
    } catch (e) {
      setState(() {
        errorMessage = "An unexpected error occurred";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 242, 242, 242),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: 620, // Slightly increased to fit dropdown and message
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Signup text
                const Text(
                  "Join Us Today!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 50),

                // Email TextField
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "Enter Email",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                // Password TextField
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Enter Password",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                // Confirm Password TextField
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                // Dropdown for user role
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedRole = newValue;
                      });
                    }
                  },
                  items:
                      <String>[
                        'Lecturer',
                        'Admin',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 20),

                // Error message display
                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),

                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: CircularProgressIndicator(),
                  ),

                const SizedBox(height: 20),

                // Sign Up button
                GestureDetector(
                  onTap:
                      isLoading
                          ? null
                          : () => signup(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            confirmPasswordController.text.trim(),
                          ),
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color:
                          isLoading
                              ? Colors.grey
                              : const Color.fromARGB(255, 0, 53, 211),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Already a member? Log In link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a member?"),
                    const SizedBox(width: 4),
                    GestureDetector(
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 53, 211),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "signin");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
