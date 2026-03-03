import 'package:flutter/material.dart';

class Topinstructor extends StatelessWidget {
  final String img;
  final String name;
  final String subtitle;
  final double rating;

  const Topinstructor({
    super.key,
    required this.img,
    required this.name,
    required this.subtitle,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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

          const SizedBox(height: 14),

          // ⭐ RATING BADGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0F24),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1C2140)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 6),
                Text(
                  rating.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
