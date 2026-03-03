import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Forgotpassword extends StatelessWidget {
  const Forgotpassword({super.key});

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
          onPressed: () => context.pop(), 
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: const Text(
        "FORGOT PASSWORD",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 1.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
       body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Image.network(
                'https://img.icons8.com/fluency/96/music.png',
                height: 70,
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              "Reset your password",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              "Enter your email address and we'll\nsend you instructions to reset your\npassword.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.4,
              ),
            ),
                 const SizedBox(height: 60),
                  const Text(
              "EMAIL ADDRESS",
              style: TextStyle(color: Color.fromARGB(240, 255, 255, 255), 
              letterSpacing: 1.3,
              fontSize: 12,
               fontWeight: FontWeight.bold),
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
                  hintText: "Enter your Email ",
                  prefixIcon: Icon(
                    Icons.mail_outline_rounded,
                    color: Colors.white38,
                  ),
                  
                  hintStyle: TextStyle(color: Colors.white38),
                ),
                
              ),
            ),
            const SizedBox(height: 30),

            Center(
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed('');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1437EF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Send Reset Link",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 140),
  Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Remember your password? ",
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
                      "Back to Login",
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
          ]

        ),

    ),
    );
    
  }
}
