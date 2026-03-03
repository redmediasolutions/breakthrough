// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class Custombottomlesson extends StatefulWidget {
  const Custombottomlesson({super.key});

  @override
  State<Custombottomlesson> createState() => CustombottomlessonState();
}

class CustombottomlessonState extends State<Custombottomlesson> {
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
          nav(Icons.play_circle_fill_rounded, "Lessons", 1),
          nav(Icons.stacked_line_chart_sharp, "Stats", 2),
          nav(Icons.person, "Profile", 3),
        ],
      ),
    );
  }

  // Single 
  Widget nav(IconData icon, String label, int index) {
    bool selected = selectedindex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedindex = index;
        });
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
