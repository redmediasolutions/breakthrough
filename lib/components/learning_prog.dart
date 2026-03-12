import 'package:flutter/material.dart';

class LearningProgress extends StatelessWidget {
  final String lessontitle;
  final String coursetitle;
  final String img;
  final double progress;
  final String buttontext;
  final IconData buttonIcon;

  const LearningProgress({
    super.key,
    required this.lessontitle,
    required this.coursetitle,
    required this.img,
    required this.progress,
    required this.buttontext,
    this.buttonIcon = Icons.play_arrow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 420, 
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2037),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // LEFT SIDE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (lessontitle.trim().isNotEmpty) ...[
                  Text(
                    lessontitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white54,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],

                Text(
                  coursetitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "${(progress * 100).toInt()}% Complete",
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 6),

                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(
                      Color(0xFF1437EF),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  width: 300,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1437EF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(buttonIcon, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        buttontext,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // RIGHT SIDE IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 100,
              height: 180,
              child: Image.network(
                img,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
