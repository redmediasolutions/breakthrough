// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:breakthrough/components/aboutinstructor.dart';
import 'package:breakthrough/components/buybottombar.dart';
import 'package:breakthrough/components/videoplayer.dart';
import 'package:breakthrough/model/instructormodel.dart';
import 'package:breakthrough/services/auth_provider.dart';
import 'package:breakthrough/services/firestore.dart';
import 'package:provider/provider.dart';

class Coursedetails extends StatelessWidget {
  final Map<String, dynamic> courseData;

  const Coursedetails({super.key, required this.courseData});

  DocumentReference<Map<String, dynamic>>? _resolveInstructorRef() {
    final dynamic instructorRef = courseData['instructorRef'];
    if (instructorRef is DocumentReference<Map<String, dynamic>>) {
      return instructorRef;
    }
    if (instructorRef is DocumentReference) {
      return FirebaseFirestore.instance.doc(instructorRef.path);
    }

    final dynamic instructorIdField = courseData['instructorID'];
    if (instructorIdField is String && instructorIdField.trim().isNotEmpty) {
      final raw = instructorIdField.trim();
      final normalized = raw.startsWith('/') ? raw.substring(1) : raw;
      if (normalized.contains('/')) {
        return FirebaseFirestore.instance.doc(normalized);
      }
      return FirebaseFirestore.instance.collection('instructors').doc(normalized);
    }

    return null;
  }

  DocumentReference<Map<String, dynamic>>? _resolveCourseRef() {
    final dynamic courseRef = courseData['courseRef'];
    if (courseRef is DocumentReference<Map<String, dynamic>>) {
      return courseRef;
    }
    if (courseRef is DocumentReference) {
      return FirebaseFirestore.instance.doc(courseRef.path);
    }
    if (courseRef is String && courseRef.trim().isNotEmpty) {
      final raw = courseRef.trim();
      final normalized = raw.startsWith('/') ? raw.substring(1) : raw;
      return FirebaseFirestore.instance.doc(normalized);
    }

    final courseId = courseData['courseId']?.toString();
    if (courseId != null && courseId.isNotEmpty) {
      return FirebaseFirestore.instance.collection('Courses').doc(courseId);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final instructorRef = _resolveInstructorRef();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101322),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: const Text(
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

            /// VIDEO PLAYER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Videoplayer(
                videourl:
                    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                thumbnailurl: courseData['courseimage'] ?? "",
              ),
            ),

            const SizedBox(height: 20),

            /// INSTRUCTOR SECTION
            if (instructorRef != null)
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: instructorRef.snapshots(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Unable to load instructor: ${snapshot.error}",
                        style: const TextStyle(color: Colors.white60),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data?.data() == null) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Instructor not found",
                        style: TextStyle(color: Colors.white60),
                      ),
                    );
                  }

                  final rawData = snapshot.data!.data()!;

                  final instructor =
                      InstructorModel.fromMap(rawData, snapshot.data!.id);

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
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Instructor information unavailable",
                  style: TextStyle(color: Colors.white60),
                ),
              ),

            const SizedBox(height: 20),

            /// COURSE TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                courseData['coursename'] ?? "Untitled Course",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// DESCRIPTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    courseData['coursedescription'] ??
                        "No description available.",
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

            /// LESSONS CTA
            Builder(
              builder: (context) {
                final courseRef = _resolveCourseRef();
                final auth = context.watch<AuthProvider>();
                final user = auth.user;
                if (courseRef == null || user == null) {
                  return const SizedBox.shrink();
                }

                final userRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid);

                return StreamBuilder<bool>(
                  stream: FirestoreService().isEnrolled(
                    userRef: userRef,
                    courseRef: courseRef,
                  ),
                  builder: (context, enrolledSnap) {
                    final isEnrolled = enrolledSnap.data ?? false;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141831),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF1E2140)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "LESSONS",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "View all course lessons",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: isEnrolled
                                  ? () {
                                      context.pushNamed(
                                        'lessonslist',
                                        extra: courseData,
                                      );
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isEnrolled
                                    ? const Color(0xFF1437EF)
                                    : const Color(0xFF1E2140),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                              ),
                              icon: Icon(
                                isEnrolled ? Icons.play_arrow : Icons.lock,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: Text(
                                isEnrolled ? "View Lessons" : "Locked",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      bottomNavigationBar: Buybottombar(
        title: "LIFETIME ACCESS",
        price: "₹${courseData['courseprice']}",
        buttontext: "Buy Now",
      ),
    );
  }
}

