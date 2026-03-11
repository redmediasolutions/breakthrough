// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class NextLessonCard extends StatelessWidget {
  final String lessonnumber;
  final String title;
  final String subtitle;
  final String duration;
  final String thumbnail;
  final bool islocked;
  final bool showDurationBadge;
 

  const NextLessonCard({
    super.key,
    required this.lessonnumber,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.thumbnail,
    this.islocked = false,
    this.showDurationBadge = true,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Image.network(
                      thumbnail,
                      width: 95,
                      height: 95,
                      fit: BoxFit.cover,
                    ),

                    // Duration
                    if (showDurationBadge)
                      Positioned(
                        bottom: 2,
                        left: 50,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            duration,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                    // Play or Lock Icon
                    Positioned(
                      bottom: 9,
                      top: 0,
                      right: 36,
                      child: Icon(
                        islocked ? Icons.lock : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 23,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LESSON
                    Text(
                      lessonnumber.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF1437EF),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // TITLE
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // SUBTITLE
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        if (islocked)
  Positioned.fill(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0D0F24).withOpacity(0.75),
            const Color(0xFF0D0F24).withOpacity(0.55),
            const Color(0xFF0D0F24).withOpacity(0.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
  ),

        ],
      ),
    );
  }
}
