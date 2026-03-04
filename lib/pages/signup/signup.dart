import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:breakthrough/components/categorysign.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),

      appBar: AppBar(
        backgroundColor: const Color(0xFF101322),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(), //login
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: const Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Start Your Musical\nJourney",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              "Affordable video courses from world-class \ninstructors.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 30),

            // Full Name Field
            const Text(
              "Full Name",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E2140),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  border: InputBorder.none,
                  hintText: "Enter your full name",
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Email 
            const Text(
              "Email Address",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E2140),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  border: InputBorder.none,
                  hintText: "name@example.com",
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Password 
           const Text(
  "Password",
  style: TextStyle(color: Colors.white70, fontSize: 14),
),
SizedBox(height: 8),

Container(
  decoration: BoxDecoration(
    color: Color(0xFF1E2140),
    borderRadius: BorderRadius.circular(12),
  ),
  child: const TextField(
    obscureText: true,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      border: InputBorder.none,
      hintText: "Min 8 characters",
      hintStyle: TextStyle(color: Colors.white38),

      suffixIcon: Icon(
        Icons.remove_red_eye,
        color: Colors.white38,
      ),
    ),
  ),
),

SizedBox(height: 8),
const Text(
  "Confirm Password",
  style: TextStyle(color: Colors.white70, fontSize: 14),
),
SizedBox(height: 8),

Container(
  decoration: BoxDecoration(
    color: Color(0xFF1E2140),
    borderRadius: BorderRadius.circular(12),
  ),
  child: const TextField(
    obscureText: true,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      border: InputBorder.none,
      hintText: "Repeat your password",
      hintStyle: TextStyle(color: Colors.white38),

    
      suffixIcon: Icon(
        Icons.remove_red_eye,
        color: Colors.white38,
      ),
    ),
  ),
),
            const SizedBox(height: 20),
             const Text(
              "What do you want to learn?",
              style: TextStyle(
                color: Color.fromARGB(215, 255, 255, 255),
                fontSize: 12,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),

 const SizedBox(height: 20),

Wrap(
  children: const [
    Category(icon: Icons.piano, label: "Piano"),
    Category(icon: Icons.mic, label: "Vocals"),
    Category(icon: Icons.music_note, label: "Drums"),
    Category(icon: Icons.music_note_sharp, label: "Guitar"),
    Category(icon: Icons.headphones, label: "Production"),
  ],
),
            const  SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 250,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1437EF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Color(0xFF8A93BE),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                     context.pushNamed('loginpage');

                    }, // Geos  to Login
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xFF1437EF),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            
            Center(
              child: Text.rich(
                const TextSpan(
                  text: "BY SIGNING UP , YOU AGREE TO OUR\n",
                  style: TextStyle(
                    color: Color(0xFF42517A),
                    fontSize:9,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: "TERMS OF SERVICE & PRIVACY POLICY.",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                       
                        decorationColor: Color(0xFF8A93BE)),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),  
          ],
        ),
      ),
    );
  }
}
