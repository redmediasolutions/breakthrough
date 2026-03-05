// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:breakthrough/services/auth_provider.dart';
import 'package:breakthrough/components/coursecards.dart';
import 'package:breakthrough/components/learning_prog.dart';
import 'package:breakthrough/components/smallcoursecards.dart';
import 'package:breakthrough/model/coursesmodel.dart';
import 'package:breakthrough/services/firestore.dart';

class Homelanding extends StatelessWidget {
  const Homelanding({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    String userName = "Guest";
    if (auth.isLoading) {
      userName = "Loading...";
    } else if (auth.userData != null) {
      userName = auth.userData!['fullName'] ?? "User";
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP SECTION
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pushNamed('profile'),
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                            "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&auto=format&fit=crop&q=60",
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "WELCOME BACK",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              letterSpacing: 1.6,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2140),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.white54),
                    hintText: "Search music courses...",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // CONTINUE LEARNING HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Continue Learning",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "View All",
                    style: TextStyle(
                      color: Color(0xFF1437EF),
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // HORIZONTAL SCROLL (Learning Progress)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: const [
                  SizedBox(width: 20),
                  LearningProgress(
                    lessontitle: "Lesson 4: Major Scales",
                    coursetitle: "Mastering Jazz\nGuitar",
                    img: "https://i.imgur.com/DvpvklR.png",
                    progress: 0.75,
                    buttontext: "Resume",
                  ),
                  LearningProgress(
                    lessontitle: "Lesson 2: Chords",
                    coursetitle: "Acoustic\nBasics",
                    img: "https://i.imgur.com/BoN9kdC.png",
                    progress: 0.40,
                    buttontext: "Resume",
                  ),
                  LearningProgress(
                    lessontitle: "Lesson 1: Introduction",
                    coursetitle: "Music Theory\nFundamentals",
                    img: "https://i.imgur.com/BoN9kdC.png",
                    progress: 0.90,
                    buttontext: "Resume",
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Featured Courses",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1437EF).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "TRENDING",
                      style: TextStyle(
                        color: Color(0xFF1437EF),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Courses List (Dynamic)
            SizedBox(
              height: 260,
              child: StreamBuilder<List<Coursesmodel>>(
                stream: FirestoreService().listofCourses,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No courses available",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  final courses = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: courses.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
      
                            context.pushNamed(
                              'coursedetails',
                              extra: {
                                'coursename': course.coursename,
                                'courseprice': course.courseprice,
                                'coursedescription': course.coursedescription,
                                'instructorID': course.instructorID,
                                'instructorRef': course.instructorRef,
                                'courseimage': course.courseimage,
                              },
                            );
                          },
                          child: Coursecards(
                            img: course.courseimage,
                            lessons: "${course.userssignedup} Lessons",
                            title: course.coursename,
                            instructor: course.coursedescription,
                            price: "₹${course.courseprice}",
                            oldPrice: "₹${course.courseprice}",
                            rating: (course.userssignedup).toDouble(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Budget Friendly Picks",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: const [
                  SmallCourseCard(
                    img:
                        "https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=500&auto=format&fit=crop&q=60",
                    title: "Rock Drumming Basics",
                    instructor: "James Taylor",
                    price: "₹299",
                    discount: "70% OFF",
                  ),
                  SmallCourseCard(
                    img:
                        "https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=500&auto=format&fit=crop&q=60",
                    title: "Rock Drumming Basics",
                    instructor: "James Taylor",
                    price: "₹499",
                    discount: "LIMITED",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
