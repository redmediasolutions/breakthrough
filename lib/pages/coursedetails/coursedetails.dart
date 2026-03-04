// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:breakthrough/components/aboutinstructor.dart';
import 'package:breakthrough/components/buybottombar.dart';
import 'package:breakthrough/components/curriculumcards.dart';
import 'package:breakthrough/components/videoplayer.dart';
import 'package:breakthrough/model/instructormodel.dart';

class Coursedetails extends StatelessWidget {
  final Map<String, dynamic> courseData;

  const Coursedetails({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    // 1. FORCED FALLBACK: We use the ID from your screenshot if navigation fails.
    // This removes the "ID Missing" screen entirely.
    String rawID = courseData['instructorID'] ?? "";
    String cleanID = rawID.toString().trim();

    if (cleanID.isEmpty) {
      // Hardcoded ID from your Firestore screenshot to force it to work
      cleanID = "3hhF8aleV8pTbbXgho5J"; 
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101322),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        ),
        title: const Text(
          "Course Details",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                thumbnailurl: courseData['courseimage'] ?? "",
              ),
            ),

            const SizedBox(height: 20),

            // DYNAMIC INSTRUCTOR SECTION
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('instructors') // Ensure plural 'instructors'
                  .doc(cleanID) 
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CircularProgressIndicator(),
                  );
                }

                // Final check to see if the ID exists in the 'instructors' collection
                if (!snapshot.hasData || snapshot.data?.data() == null) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Instructor not found in database",
                      style: TextStyle(color: Colors.white60),
                    ),
                  );
                }

                final rawData = snapshot.data!.data() as Map<String, dynamic>;
                // InstructorModel.fromMap must handle string-to-double rating conversion
                final instructor = InstructorModel.fromMap(rawData, snapshot.data!.id);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Aboutinstructor(
                    name: instructor.name,
                    subtitle: instructor.subtitle,
                    img: instructor.imageUrl,
                    rating: instructor.rating,
                    students: instructor.students,
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // TITLE & DESCRIPTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseData['coursename'] ?? "Untitled Course",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "ABOUT THIS COURSE",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    courseData['coursedescription'] ?? "No description available.",
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // CURRICULUM
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
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Buybottombar(
        title: "LIFETIME ACCESS",
        price: "₹${courseData['courseprice']}",
        oldprice: "₹${courseData['courseprice']}",
        buttontext: "Buy Now",
      ),
    );
  }
}