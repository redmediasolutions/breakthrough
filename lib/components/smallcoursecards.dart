// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class SmallCourseCard extends StatelessWidget {
  final String img;
  final String title;
  final String instructor;
  final String price;
  final VoidCallback? onTap;
  final VoidCallback? onAddTap;
  final bool showPrice;
  final bool isInCart;

  const SmallCourseCard({
    super.key,
    required this.img,
    required this.title,
    required this.instructor,
    required this.price,
    this.onTap,
    this.onAddTap,
    this.showPrice = true,
    this.isInCart = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                  "By $instructor",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                if (showPrice)
                  Text(
                    price,
                    style: const TextStyle(
                      color: Color(0xFF1437EF),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  )
              ],
            ),
          ),

          if (showPrice)
            TextButton(
              onPressed: isInCart ? null : onAddTap,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                backgroundColor: (isInCart
                        ? const Color(0xFF1E2140)
                        : const Color(0xFF1437EF))
                    .withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isInCart ? "ADDED" : "ADD TO CART",
                style: TextStyle(
                  color: isInCart
                      ? Colors.white54
                      : const Color(0xFF7FA0FF),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
