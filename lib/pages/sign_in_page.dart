import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = "";
  bool isLoading = false;

  Future<void> signIn(String email, String password) async {
    if (!EmailValidator.validate(email)) {
      setState(() {
        errorMessage = "Invalid email format";
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
        errorMessage = "";
      });

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid; // Get user ID
      print("Signed in successfully: $uid");

      // Clear input fields
      emailController.clear();
      passwordController.clear();

      Navigator.pushNamed(
        context,
        "home",
      ); // Navigate to home page after success
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
          height: 500,
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Login text
                const Text(
                  "Welcome back!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 50),

                // TextField for email
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "Enter Email",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                // TextField for password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Enter Password",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 30),

                // Error message display
                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),

                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: CircularProgressIndicator(),
                  ),

                const SizedBox(height: 20),

                // Sign In button
                GestureDetector(
                  onTap:
                      isLoading
                          ? null
                          : () => signIn(
                            emailController.text.trim(),
                            passwordController.text.trim(),
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
                        "Sign In",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Don't have an account? Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't Have an account?"),
                    const SizedBox(width: 4),
                    GestureDetector(
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 53, 211),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "signup");
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
