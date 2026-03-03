// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F24),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        // leading:  IconButton(
        //   onPressed: () {
        //     context.go('/home');
        //   },
        //    icon: Icon(Icons.arrow_back_ios_new_rounded,
        //           color: Colors.white, size: 20),
        // ),
        title:   Text(
              "Profile",
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
  padding: const EdgeInsets.symmetric(vertical: 20),
  child: Column(
    children: [
      // PROFILE IMAGE 
      Stack(
        children: [
          // Outer Blue Border
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3C5BFF),
                  Color(0xFF1437EF),
                ],
              ),
            ),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: const Color(0xFF0D0F24),
              backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&auto=format&fit=crop&q=60", 
              ),
            ),
          ),

          // Verified Badge
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xFF1437EF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 14),

      // NAME
      const Text(
        "Keerthan Rao",
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 10),

      // MEMBERSHIP TAG
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1437EF).withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF1437EF), width: 1),
        ),
        child: const Text(
          "BREAKTHROUGH PLUS MEMBER",
          style: TextStyle(
            color: Color(0xFF3C5BFF),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    ],
  ),
),
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    // SECTION TITLE
    const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "GENERAL",
        style: TextStyle(
          color: Colors.white38,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.6,
        ),
      ),
    ),

    // ACCOUNT SETTINGS
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GestureDetector(
        onTap: () {
          context.pushNamed('accountsettings');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D2F),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.person, color: Color(0xFF3C5BFF), size: 24),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  "Account Settings",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
            ],
          ),
        ),
      ),
    ),

    // MY PURCHASES
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GestureDetector(
        onTap: () {
          context.pushNamed('purchasehistory');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D2F),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.shopping_bag, color: Color(0xFF3C5BFF), size: 24),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  "My Purchases",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
            ],
          ),
        ),
      ),
    ),

  
    // LOGOUT
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GestureDetector(
        onTap: () {
            context.goNamed('loginpage');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D2F),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.logout, color: Colors.red, size: 24),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.red, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
)


          ]
        ),
       ),


    );
  }
}
