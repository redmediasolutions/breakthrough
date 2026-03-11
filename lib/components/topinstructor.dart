import 'package:flutter/material.dart';

class Topinstructor extends StatelessWidget {
  final String img;
  final String name;
  final String subtitle;
  final VoidCallback? onTap;

  const Topinstructor({
    super.key,
    required this.img,
    required this.name,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF11152C),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF1C2037)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // PROFILE IMAGE
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(img),
            ),

            const SizedBox(height: 14),

            // NAME
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 4),

            // SUBTITLE
            Text(
              subtitle.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF5C6BC0),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
