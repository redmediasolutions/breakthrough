// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Custombottomhome extends StatefulWidget {
  const Custombottomhome({super.key});

  @override
  State<Custombottomhome> createState() => CustombottomhomeState();
}

class CustombottomhomeState extends State<Custombottomhome> {
  int selectedindex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1126), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          nav(Icons.home_rounded, "Home", 0),
          nav(Icons.explore_rounded, "Explore", 1),
          nav(Icons.school_rounded, "Learning", 2),
          nav(Icons.person_rounded, "Profile", 3),
        ],
      ),
    );
  }

  // Single 
  Widget nav(IconData icon, String label, int index) {
    bool selected = selectedindex == index;

    return GestureDetector(
      onTap: () {
        if (index == 3) {
          context.pushNamed('profile');
        } else {
          setState(() {
            selectedindex = index;
          });
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,
            color: selected
                ? const Color(0xFF4B6AFF) 
                : Colors.white54,         
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected
                  ? const Color(0xFF4B6AFF)
                  : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
