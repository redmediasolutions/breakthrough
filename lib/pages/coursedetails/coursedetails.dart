// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclearner/components/aboutinstructor.dart';
import 'package:musiclearner/components/buybottombar.dart';
import 'package:musiclearner/components/curriculumcards.dart';
import 'package:musiclearner/components/videoplayer.dart';


class Coursedetails extends StatelessWidget {
 

  const Coursedetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),

      appBar: AppBar(
        backgroundColor: const Color(0xFF101322),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.go('/home');
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          "Course Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share, color: Colors.white, size: 20),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // VIDEO PLAYER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Videoplayer(
                videourl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                thumbnailurl:"https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGlhbm98ZW58MHx8MHx8fDA%3D"
              ),
            ),

            const SizedBox(height: 20),

            // TITLE & BESTSELLER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1437EF).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: Text(
                        "BESTSELLER",
                        style: TextStyle(
                          color: Color(0xFF1437EF),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Mastering the Electric\nGuitar: Blues Basics",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // INSTRUCTOR SECTION
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Aboutinstructor(
                name: "Alex Johnson",
                subtitle: "Expert Blues Guitarist • 12 years exp.",
                img:
                    "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&q=60",
                rating: 4.9,
                students: "12.6K",
              ),
            ),

            const SizedBox(height: 20),

            // ABOUT THIS COURSE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "ABOUT THIS COURSE",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Take your skills from beginner to pro with over 10 hours of premium video content. "
                    "Learn essential techniques, blues scales, rhythm patterns, and more.",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Read More",
                    style: TextStyle(
                      color: Color(0xFF1437EF),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // CURRICULUM TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "CURRICULUM",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    "24 Lessons • 10h 45m",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // LESSON LIST
            CurriculumList(
              lessons: [
                CurriculumItem(
                  title: "1. Introduction to the Blues Scale",
                  duration: "12:45",
                  locked: false,
                  freepreview: true,
                ),
                CurriculumItem(
                  title: "2. Finger Positioning and Warmups",
                  duration: "08:30",
                  locked: true,
                ),
                CurriculumItem(
                  title: "3. Rhythm and Timing Essentials",
                  duration: "24:12",
                  locked: true,
                ),
                CurriculumItem(
                  title: "4. Your First 12-Bar Progression",
                  duration: "19:50",
                  locked: true,
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "View All Lessons",
                style: TextStyle(
                  color: Color(0xFF8A93BE),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      bottomNavigationBar: const Buybottombar(
        title: "LIFETIME ACCESS",
        price: "₹499",
        oldprice: "₹2,499",
        buttontext: "Buy Now",
      ),
    );
  }
}
