import 'package:flutter/material.dart';

class Aboutinstructor extends StatelessWidget {
  final String name;
  final String subtitle;
  final String img;
  final double rating;
  final String students;

  const Aboutinstructor({
    super.key,
    required this.name,
    required this.subtitle,
    required this.img,
    required this.rating,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // PHOTO
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            img,
            width: 55,
            height: 55,
            fit: BoxFit.cover,
          ),
        ),
    
        const SizedBox(width: 12),
    
        // NAME & SUBTITLE
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
    
              const SizedBox(height: 4),
    
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
    
        // RATING & STUDENTS
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  rating.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 18,
                ),
              ],
            ),
    
            const SizedBox(height: 6),
    
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    students,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const Text(
                    "STUDENTS",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
