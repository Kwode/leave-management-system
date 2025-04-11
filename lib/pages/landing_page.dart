import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 100.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Leave\nManagement\nSystem",
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        height: 0,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Simplify leave management and streamline\napproval workflows with our comprehensive\nsoftware solution",
                      style: TextStyle(color: Colors.grey[700], fontSize: 20),
                    ),

                    SizedBox(height: 25),

                    MouseRegion(
                      cursor:
                          SystemMouseCursors
                              .click, // Changes the cursor to a clickable hand
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "signin");
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
                              "Get Started",
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

              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/images/undraw_booking_1ztt.png"),
                      fit: BoxFit.contain,
                    ),
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
