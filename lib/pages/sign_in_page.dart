import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          height: 500,
          width: 500,
          child: Form(
            key: _formKey, // Key for form validation
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Sign In
                Text(
                  "Welcome Back!",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 40),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    // Add more email validation logic here if needed
                    return null; // No error
                  },
                ),
                SizedBox(height: 20),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null; // No error
                  },
                ),
                SizedBox(height: 20),
                // Get Started Button
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // If the form is valid, navigate to the 'signin' page
                        Navigator.pushNamed(context, "signin");
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 53, 211),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
