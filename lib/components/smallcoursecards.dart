// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class SmallCourseCard extends StatelessWidget {
  final String img;
  final String title;
  final String instructor;
  final String price;
  final String discount;

  const SmallCourseCard({
    super.key,
    required this.img,
    required this.title,
    required this.instructor,
    required this.price,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2037),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
            img,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  instructor,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        color:Color(0xFF1437EF),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B403B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        discount,
                        style: const TextStyle(
                          color: Color(0xFF42C675),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          // ARROW BUTTON 
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.chevron_right,
              size: 22,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
