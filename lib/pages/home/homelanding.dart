// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:breakthrough/services/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breakthrough/components/coursecards.dart';
import 'package:breakthrough/components/learning_prog.dart';
import 'package:breakthrough/components/smallcoursecards.dart';
import 'package:breakthrough/model/coursesmodel.dart';
import 'package:breakthrough/model/instructormodel.dart';
import 'package:breakthrough/services/firestore.dart';

class Homelanding extends StatelessWidget {
  const Homelanding({super.key});

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

            // HORIZONTAL SCROLL (Learning Progress)
            if (auth.user != null)
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('Enrollments')
                    .where(
                      'userRef',
                      isEqualTo: FirebaseFirestore.instance
                          .collection('users')
                          .doc(auth.user!.uid),
                    )
                    .where('status', isEqualTo: 'active')
                    .snapshots(),
                builder: (context, enrollSnap) {
                  if (enrollSnap.connectionState ==
                      ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }
                  if (!enrollSnap.hasData || enrollSnap.data!.docs.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final enrollments = enrollSnap.data!.docs;

                  Future<List<_HomeLearningItem>> loadItems() async {
                    final items = <_HomeLearningItem>[];
                    final userRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(auth.user!.uid);

                    for (final enrollment in enrollments) {
                      final data = enrollment.data();
                      final courseRef = data['courseRef']
                          as DocumentReference<Map<String, dynamic>>?;
                      if (courseRef == null) continue;

                      final courseSnap = await courseRef.get();
                      final courseData = courseSnap.data();
                      if (courseData == null) continue;

                      final courseName =
                          courseData['coursename']?.toString() ?? 'Course';
                      final courseImage =
                          courseData['courseimage']?.toString() ?? '';

                      final lessonsSnap = await FirebaseFirestore.instance
                          .collection('Lessons')
                          .where('courseRef', isEqualTo: courseRef)
                          .orderBy('order')
                          .get();

                      final lessons = lessonsSnap.docs
                          .map((doc) => _HomeLessonBrief.fromDoc(doc))
                          .toList();

                      if (lessons.isEmpty) continue;

                      final progressSnap = await FirebaseFirestore.instance
                          .collection('Progress')
                          .where('userRef', isEqualTo: userRef)
                          .where('courseRef', isEqualTo: courseRef)
                          .limit(1)
                          .get();

                      final progressData = progressSnap.docs.isEmpty
                          ? null
                          : progressSnap.docs.first.data();
                      final completedIds =
                          (progressData?['completedLessonIds']
                                      as List<dynamic>? ??
                                  [])
                              .map((e) => e.toString())
                              .toSet();

                      final completedCount = completedIds.length;
                      final totalLessons = lessons.length;
                      final progressValue = totalLessons == 0
                          ? 0.0
                          : (completedCount / totalLessons)
                              .clamp(0.0, 1.0);
                      if (progressValue >= 1.0) continue;

                      final nextLesson = lessons.firstWhere(
                        (lesson) => !completedIds.contains(lesson.id),
                        orElse: () => lessons.last,
                      );

                      items.add(
                        _HomeLearningItem(
                          courseRef: courseRef,
                          courseName: courseName,
                          courseImage: courseImage,
                          progressValue: progressValue,
                          lessonLabel:
                              "Lesson ${nextLesson.order}: ${nextLesson.name}",
                          nextLesson: nextLesson,
                        ),
                      );
                    }

                    return items;
                  }

                  return FutureBuilder<List<_HomeLearningItem>>(
                    future: loadItems(),
                    builder: (context, itemsSnap) {
                      if (itemsSnap.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }
                      final items = itemsSnap.data ?? [];
                      if (items.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Continue Learning",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    letterSpacing: 1.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      context.pushNamed('learningpage'),
                                  child: const Text(
                                    "View All",
                                    style: TextStyle(
                                      color: Color(0xFF1437EF),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 230,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                      'lessonplayer',
                                      extra: {
                                        'lessonId': item.nextLesson.id,
                                        'lessonName': item.nextLesson.name,
                                        'lessonDescription':
                                            item.nextLesson.description,
                                        'videoUrl': item.nextLesson.videoUrl,
                                        'thumbnail': item.nextLesson.thumbnail,
                                        'courseRef': item.courseRef,
                                      },
                                    );
                                  },
                                  child: LearningProgress(
                                    lessontitle: item.lessonLabel,
                                    coursetitle: item.courseName,
                                    img: item.courseImage.isNotEmpty
                                        ? item.courseImage
                                        : "https://i.imgur.com/BoN9kdC.png",
                                    progress: item.progressValue,
                                    buttontext: "Resume",
                                    buttonIcon: Icons.play_arrow,
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 12),
                              itemCount: items.length,
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      );
                    },
                  );
                },
              ),
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
                                'courseId': course.id,
                                'courseRef': FirebaseFirestore.instance
                                    .collection('Courses')
                                    .doc(course.id),
                                'courseprice': course.courseprice,
                                'coursedescription': course.coursedescription,
                                'instructorID': course.instructorID,
                                'instructorRef': course.instructorRef,
                                'courseimage': course.courseimage,
                              },
                            );
                          },
                          child: Builder(
                            builder: (context) {
                              final instructorRef =
                                  _resolveInstructorRef(course);
                              final courseRef = FirebaseFirestore.instance
                                  .collection('Courses')
                                  .doc(course.id);
                              final user = auth.user;
                              final userRef = user == null
                                  ? null
                                  : FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid);

                              if (userRef == null) {
                                return StreamBuilder<int>(
                                  stream: FirestoreService()
                                      .lessonCountForCourse(courseRef),
                                  builder: (context, countSnap) {
                                    final lessonCount =
                                        countSnap.data ?? 0;
                                    return Coursecards(
                                      img: course.courseimage,
                                      lessons: "$lessonCount Lessons",
                                      title: course.coursename,
                                      instructor: "Instructor",
                                      price: "\u20B9${course.courseprice}",
                                    );
                                  },
                                );
                              }

                              return StreamBuilder<bool>(
                                stream: FirestoreService().isEnrolled(
                                  userRef: userRef,
                                  courseRef: courseRef,
                                ),
                                builder: (context, enrolledSnap) {
                                  final isEnrolled = enrolledSnap.data ?? false;

                                  if (instructorRef == null) {
                                    return StreamBuilder<int>(
                                      stream: FirestoreService()
                                          .lessonCountForCourse(courseRef),
                                      builder: (context, countSnap) {
                                        final lessonCount =
                                            countSnap.data ?? 0;
                                        return Coursecards(
                                          img: course.courseimage,
                                          lessons: "$lessonCount Lessons",
                                          title: course.coursename,
                                          instructor: "Instructor",
                                          price: "\u20B9${course.courseprice}",
                                          showPrice: !isEnrolled,
                                        );
                                      },
                                    );
                                  }

                                  return StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: instructorRef.snapshots(),
                                    builder: (context, snapshot) {
                                      String instructorName = "Instructor";
                                      if (snapshot.hasData &&
                                          snapshot.data?.data() != null) {
                                        final instructor =
                                            InstructorModel.fromMap(
                                          snapshot.data!.data()!,
                                          snapshot.data!.id,
                                        );
                                        instructorName =
                                            instructor.name.isNotEmpty
                                                ? instructor.name
                                                : instructorName;
                                      }

                                      return StreamBuilder<int>(
                                        stream: FirestoreService()
                                            .lessonCountForCourse(courseRef),
                                        builder: (context, countSnap) {
                                          final lessonCount =
                                              countSnap.data ?? 0;
                                          return Coursecards(
                                            img: course.courseimage,
                                            lessons: "$lessonCount Lessons",
                                            title: course.coursename,
                                            instructor: instructorName,
                                            price:
                                                "\u20B9${course.courseprice}",
                                            showPrice: !isEnrolled,
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
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

                  final courses = snapshot.data!.take(2).toList();

                  return Column(
                    children: courses
                        .map(
                          (course) => Builder(
                            builder: (context) {
                              final instructorRef =
                                  _resolveInstructorRef(course);
                              final user = auth.user;
                              final userRef = user == null
                                  ? null
                                  : FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid);
                              final courseRef = FirebaseFirestore.instance
                                  .collection('Courses')
                                  .doc(course.id);

                              if (userRef == null) {
                                return SmallCourseCard(
                                  img: course.courseimage,
                                  title: course.coursename,
                                  instructor: "Instructor",
                                  price: "\u20B9${course.courseprice}",
                                  onTap: () {
                                    context.pushNamed(
                                      'coursedetails',
                                      extra: {
                                        'coursename': course.coursename,
                                        'courseId': course.id,
                                        'courseRef': courseRef,
                                        'courseprice': course.courseprice,
                                        'coursedescription':
                                            course.coursedescription,
                                        'instructorID': course.instructorID,
                                        'instructorRef': course.instructorRef,
                                        'courseimage': course.courseimage,
                                      },
                                    );
                                  },
                                );
                              }

                              return StreamBuilder<bool>(
                                stream: FirestoreService().isEnrolled(
                                  userRef: userRef,
                                  courseRef: courseRef,
                                ),
                                builder: (context, enrolledSnap) {
                                  final isEnrolled =
                                      enrolledSnap.data ?? false;

                                  if (instructorRef == null) {
                                    return SmallCourseCard(
                                      img: course.courseimage,
                                      title: course.coursename,
                                      instructor: "Instructor",
                                      price: "\u20B9${course.courseprice}",
                                      showPrice: !isEnrolled,
                                      onTap: () {
                                        context.pushNamed(
                                          'coursedetails',
                                          extra: {
                                            'coursename': course.coursename,
                                            'courseId': course.id,
                                            'courseRef': courseRef,
                                            'courseprice':
                                                course.courseprice,
                                            'coursedescription':
                                                course.coursedescription,
                                            'instructorID':
                                                course.instructorID,
                                            'instructorRef':
                                                course.instructorRef,
                                            'courseimage': course.courseimage,
                                          },
                                        );
                                      },
                                    );
                                  }

                                  return StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: instructorRef.snapshots(),
                                    builder: (context, snapshot) {
                                      String instructorName = "Instructor";
                                      if (snapshot.hasData &&
                                          snapshot.data?.data() != null) {
                                        final instructor =
                                            InstructorModel.fromMap(
                                          snapshot.data!.data()!,
                                          snapshot.data!.id,
                                        );
                                        instructorName =
                                            instructor.name.isNotEmpty
                                                ? instructor.name
                                                : instructorName;
                                      }

                                      return SmallCourseCard(
                                        img: course.courseimage,
                                        title: course.coursename,
                                        instructor: instructorName,
                                        price: "\u20B9${course.courseprice}",
                                        showPrice: !isEnrolled,
                                        onTap: () {
                                          context.pushNamed(
                                            'coursedetails',
                                            extra: {
                                              'coursename': course.coursename,
                                              'courseId': course.id,
                                              'courseRef': courseRef,
                                              'courseprice':
                                                  course.courseprice,
                                              'coursedescription':
                                                  course.coursedescription,
                                              'instructorID':
                                                  course.instructorID,
                                              'instructorRef':
                                                  course.instructorRef,
                                              'courseimage': course.courseimage,
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeLearningItem {
  final DocumentReference<Map<String, dynamic>> courseRef;
  final String courseName;
  final String courseImage;
  final double progressValue;
  final String lessonLabel;
  final _HomeLessonBrief nextLesson;

  _HomeLearningItem({
    required this.courseRef,
    required this.courseName,
    required this.courseImage,
    required this.progressValue,
    required this.lessonLabel,
    required this.nextLesson,
  });
}

class _HomeLessonBrief {
  final String id;
  final String name;
  final int order;
  final String description;
  final String videoUrl;
  final String thumbnail;

  _HomeLessonBrief({
    required this.id,
    required this.name,
    required this.order,
    required this.description,
    required this.videoUrl,
    required this.thumbnail,
  });

  factory _HomeLessonBrief.fromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return _HomeLessonBrief(
      id: doc.id,
      name: data['lessonname']?.toString() ?? 'Lesson',
      order: int.tryParse(data['order']?.toString() ?? '') ?? 1,
      description: data['lessondescription']?.toString() ?? '',
      videoUrl: data['videoUrl']?.toString() ?? '',
      thumbnail: data['thumbnail']?.toString() ?? '',
    );
  }
}







