import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PurchasedPage extends StatelessWidget {
  final Map<String, dynamic>? courseData;

  const PurchasedPage({super.key, this.courseData});

  @override
  Widget build(BuildContext context) {
    final courseName =
        courseData?['coursename']?.toString() ?? "Course";
    final courseImage = courseData?['courseimage']?.toString();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B403B),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF42C675),
                  size: 48,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Purchase Successful",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your course has been unlocked.",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 26),
              if (courseImage != null && courseImage.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    courseImage,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                courseName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1437EF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Go to Home",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
