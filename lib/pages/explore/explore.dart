import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:breakthrough/components/categorysign.dart';
import 'package:breakthrough/components/coursecards.dart';
import 'package:breakthrough/components/topinstructor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breakthrough/model/coursesmodel.dart';
import 'package:breakthrough/model/instructormodel.dart';
import 'package:breakthrough/services/firestore.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  DocumentReference<Map<String, dynamic>>? _resolveInstructorRef(
      Coursesmodel course) {
    if (course.instructorRef != null) {
      return course.instructorRef;
    }

    final raw = course.instructorID.trim();
    if (raw.isEmpty) {
      return null;
    }

    final normalized = raw.startsWith('/') ? raw.substring(1) : raw;
    if (normalized.contains('/')) {
      return FirebaseFirestore.instance.doc(normalized);
    }

    return FirebaseFirestore.instance.collection('instructors').doc(normalized);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F24),
        elevation: 0,
        centerTitle: true,

        leading: const SizedBox.shrink(),

        title: const Text(
          "Explore",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2140),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.notifications,
                  color: Colors.white, size: 22),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
            // SEARCH BAR
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2140),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.white54, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            "Search instruments, artists, or skills",
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: const [
                  Category(icon: Icons.all_inbox, label: "All"),
                  SizedBox(width: 12),
                  Category(icon: Icons.piano, label: "Piano"),
                  SizedBox(width: 12),
                  Category(icon: Icons.mic, label: "Vocals"),
                  SizedBox(width: 12),
                  Category(icon: Icons.music_note, label: "Drums"),
                  SizedBox(width: 12),
                  Category(icon: Icons.music_note_sharp, label: "Guitar"),
                  SizedBox(width: 12),
                  Category(icon: Icons.headphones, label: "Production"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Trending Now",
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
                    physics: const BouncingScrollPhysics(),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Builder(
                          builder: (context) {
                            final instructorRef =
                                _resolveInstructorRef(course);
                            if (instructorRef == null) {
                              return GestureDetector(
                                onTap: () {
                                  context.pushNamed(
                                    'coursedetails',
                                    extra: {
                                      'coursename': course.coursename,
                                      'courseId': course.id,
                                      'courseRef': FirebaseFirestore.instance
                                          .collection('Courses')
                                          .doc(course.id),
                                      'courseprice': course.courseprice,
                                      'coursedescription':
                                          course.coursedescription,
                                      'instructorID': course.instructorID,
                                      'instructorRef': course.instructorRef,
                                      'courseimage': course.courseimage,
                                    },
                                  );
                                },
                                child: Coursecards(
                                  img: course.courseimage,
                                  lessons:
                                      "${course.userssignedup} Lessons",
                                  title: course.coursename,
                                  instructor: "Instructor",
                                  price: "₹${course.courseprice}",
                                ),
                              );
                            }

                            return StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              stream: instructorRef.snapshots(),
                              builder: (context, snapshot) {
                                String instructorName = "Instructor";
                                if (snapshot.hasData &&
                                    snapshot.data?.data() != null) {
                                  final instructor = InstructorModel.fromMap(
                                    snapshot.data!.data()!,
                                    snapshot.data!.id,
                                  );
                                  instructorName = instructor.name.isNotEmpty
                                      ? instructor.name
                                      : instructorName;
                                }

                                return GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                      'coursedetails',
                                      extra: {
                                        'coursename': course.coursename,
                                        'courseId': course.id,
                                        'courseRef': FirebaseFirestore.instance
                                            .collection('Courses')
                                            .doc(course.id),
                                        'courseprice': course.courseprice,
                                        'coursedescription':
                                            course.coursedescription,
                                        'instructorID': course.instructorID,
                                        'instructorRef': course.instructorRef,
                                        'courseimage': course.courseimage,
                                      },
                                    );
                                  },
                                  child: Coursecards(
                                    img: course.courseimage,
                                    lessons:
                                        "${course.userssignedup} Lessons",
                                    title: course.coursename,
                                    instructor: instructorName,
                                    price: "₹${course.courseprice}",
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Top Instructors",
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
            SizedBox(
              height: 200,
              child: StreamBuilder<List<InstructorModel>>(
                stream: FirestoreService().listOfInstructors,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No instructors available",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final instructors = snapshot.data!.take(4).toList();

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: instructors.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 15),
                    itemBuilder: (context, index) {
                      final instructor = instructors[index];
                      return Topinstructor(
                        img: instructor.imageUrl,
                        name: instructor.name,
                        subtitle: instructor.subtitle,
                        onTap: () {
                          context.pushNamed(
                            'instructordetails',
                            extra: instructor,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            )
            ],
          ),
        ),
      ),
    );
  }
}
