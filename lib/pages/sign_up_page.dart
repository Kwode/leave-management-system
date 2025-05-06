import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    final TextEditingController confirmpassword = TextEditingController();

    Future<void> signup(String email, String password) async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String uid = userCredential.user!.uid; // Get user ID

        print("Signed Up in successfully: $uid");
        Navigator.pushNamed(context, "login");
      } catch (e) {
        print("Error during sign-up: $e");
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 242, 242, 242),
          ),
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: 500,
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Login text
              Text(
                "Join Us Today!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 50),

              //textfield for email
              TextField(
                controller: email,
                decoration: InputDecoration(
                  hintText: "Enter Email",
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 0, 53, 211),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: const Color.fromARGB(255, 0, 53, 211),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              //textfield for password
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter Password",
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 0, 53, 211),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 0, 53, 211),
                      width: 2,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              //textfield for confirm password
              TextField(
                controller: confirmpassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 0, 53, 211),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 0, 53, 211),
                      width: 2,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              TextButton(
                onPressed: () {},
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 53, 211),
                  ),
                ),
              ),

              SizedBox(height: 20),

              //button
              GestureDetector(
                onTap: () => signup(email.text, password.text),
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 53, 211),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              //Already a member?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already a member?"),

                  SizedBox(width: 4),

                  GestureDetector(
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 53, 211),
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
    );
  }
}
