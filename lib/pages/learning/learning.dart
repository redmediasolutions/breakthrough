// ignore_for_file: deprecated_member_use

import 'package:breakthrough/components/learning_prog.dart';
import 'package:breakthrough/services/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Learning extends StatefulWidget {
  const Learning({super.key});

  @override
  State<Learning> createState() => _LearningState();
}

class _LearningState extends State<Learning> {
  bool _showCompleted = false;

  Future<List<_LearningCourse>> _loadLearningData({
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> enrollments,
    required DocumentReference<Map<String, dynamic>> userRef,
  }) async {
    final items = <_LearningCourse>[];

    for (final enrollment in enrollments) {
      final data = enrollment.data();
      final courseRef = data['courseRef'] as DocumentReference<Map<String, dynamic>>?;
      if (courseRef == null) continue;

      final courseSnap = await courseRef.get();
      final courseData = courseSnap.data();
      if (courseData == null) continue;

      final courseName = courseData['coursename']?.toString() ?? 'Course';
      final courseImage = courseData['courseimage']?.toString() ?? '';

      final lessonsSnap = await FirebaseFirestore.instance
          .collection('Lessons')
          .where('courseRef', isEqualTo: courseRef)
          .orderBy('order')
          .get();

      final lessons = lessonsSnap.docs
          .map((doc) => _LessonBrief.fromDoc(doc))
          .toList();

      final totalLessons = lessons.length;

      final progressSnap = await FirebaseFirestore.instance
          .collection('Progress')
          .where('userRef', isEqualTo: userRef)
          .where('courseRef', isEqualTo: courseRef)
          .limit(1)
          .get();

      final progressData =
          progressSnap.docs.isEmpty ? null : progressSnap.docs.first.data();
      final completedIds = (progressData?['completedLessonIds'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toSet();

      final completedCount = completedIds.length;
      final progressValue = totalLessons == 0
          ? 0.0
          : (completedCount / totalLessons).clamp(0.0, 1.0);
      final isCompleted = totalLessons > 0 && completedCount >= totalLessons;

      _LessonBrief? nextLesson;
      if (lessons.isNotEmpty) {
        nextLesson = lessons.firstWhere(
          (lesson) => !completedIds.contains(lesson.id),
          orElse: () => lessons.last,
        );
      }

      final lessonLabel = nextLesson == null
          ? 'No lessons'
          : 'Lesson ${nextLesson.order}: ${nextLesson.name}';

      items.add(
        _LearningCourse(
          courseRef: courseRef,
          courseName: courseName,
          courseImage: courseImage,
          totalLessons: totalLessons,
          completedCount: completedCount,
          progressValue: progressValue,
          isCompleted: isCompleted,
          lessonLabel: lessonLabel,
          nextLesson: nextLesson,
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final userRef = user == null
        ? null
        : FirebaseFirestore.instance.collection('users').doc(user.uid);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F24),
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text(
          "Learning",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Colors.white),
            ),
          ),
        ],
      ),
      body: userRef == null
          ? const Center(
              child: Text(
                "Login to view learning",
                style: TextStyle(color: Colors.white60),
              ),
            )
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Enrollments')
                  .where('userRef', isEqualTo: userRef)
                  .where('status', isEqualTo: 'active')
                  .snapshots(),
              builder: (context, enrollSnap) {
                if (enrollSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!enrollSnap.hasData || enrollSnap.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No active courses yet",
                      style: TextStyle(color: Colors.white60),
                    ),
                  );
                }

                final enrollments = enrollSnap.data!.docs;

                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('Progress')
                      .where('userRef', isEqualTo: userRef)
                      .snapshots(),
                  builder: (context, _) {
                    return FutureBuilder<List<_LearningCourse>>(
                      future: _loadLearningData(
                        enrollments: enrollments,
                        userRef: userRef,
                      ),
                      builder: (context, dataSnap) {
                        if (dataSnap.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final items = dataSnap.data ?? [];
                        if (items.isEmpty) {
                          return const Center(
                            child: Text(
                              "No learning data",
                              style: TextStyle(color: Colors.white60),
                            ),
                          );
                        }

                        final inProgress =
                            items.where((item) => !item.isCompleted).toList();
                        final completed =
                            items.where((item) => item.isCompleted).toList();

                        final visible =
                            _showCompleted ? completed : inProgress;

                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _LearningSummary(
                                totalCourses: items.length,
                                certificates: completed.length,
                              ),
                              const SizedBox(height: 20),
                              _LearningTabs(
                                showCompleted: _showCompleted,
                                onChanged: (value) {
                                  setState(() {
                                    _showCompleted = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              if (visible.isEmpty)
                                Center(
                                  child: Text(
                                    _showCompleted
                                        ? "No completed courses yet"
                                        : "Nothing in progress",
                                    style:
                                        const TextStyle(color: Colors.white60),
                                  ),
                                )
                              else
                                ...visible.map((item) {
                                  final isCompleted = item.isCompleted;
                                  final buttonText = isCompleted
                                      ? "Download Certificate"
                                      : "Resume";
                                  final buttonIcon = isCompleted
                                      ? Icons.file_download_rounded
                                      : Icons.play_arrow;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (isCompleted) {
                                          context.pushNamed(
                                            'certificate',
                                            extra: {
                                              'courseName': item.courseName,
                                              'courseImage': item.courseImage,
                                            },
                                          );
                                          return;
                                        }
                                        if (item.nextLesson == null) return;
                                        context.pushNamed(
                                          'lessonplayer',
                                          extra: {
                                            'lessonId': item.nextLesson!.id,
                                            'lessonName': item.nextLesson!.name,
                                            'lessonDescription':
                                                item.nextLesson!.description,
                                            'videoUrl':
                                                item.nextLesson!.videoUrl,
                                            'thumbnail':
                                                item.nextLesson!.thumbnail,
                                            'courseRef': item.courseRef,
                                          },
                                        );
                                      },
                                      child: LearningProgress(
                                        lessontitle:
                                            isCompleted ? "" : item.lessonLabel,
                                        coursetitle: item.courseName,
                                        img: item.courseImage.isNotEmpty
                                            ? item.courseImage
                                            : "https://i.imgur.com/BoN9kdC.png",
                                        progress: item.progressValue,
                                        buttontext: buttonText,
                                        buttonIcon: buttonIcon,
                                      ),
                                    ),
                                  );
                                }),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}

class _LearningSummary extends StatelessWidget {
  final int totalCourses;
  final int certificates;

  const _LearningSummary({
    required this.totalCourses,
    required this.certificates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF11152C),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1C2140)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "LEARNING PROGRESS",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1437EF).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.menu_book_rounded,
                        color: Color(0xFF1437EF), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$totalCourses",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "COURSES",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.emoji_events_rounded,
                        color: Color(0xFFFFC107), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$certificates",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "CERTIFICATES",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LearningTabs extends StatelessWidget {
  final bool showCompleted;
  final ValueChanged<bool> onChanged;

  const _LearningTabs({
    required this.showCompleted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2140),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: showCompleted ? Colors.transparent : const Color(0xFF0D0F24),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "In Progress",
                  style: TextStyle(
                    color: showCompleted
                        ? const Color(0xFF8A93BE)
                        : Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: showCompleted ? const Color(0xFF0D0F24) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Completed",
                  style: TextStyle(
                    color: showCompleted ? Colors.white : const Color(0xFF8A93BE),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningCourse {
  final DocumentReference<Map<String, dynamic>> courseRef;
  final String courseName;
  final String courseImage;
  final int totalLessons;
  final int completedCount;
  final double progressValue;
  final bool isCompleted;
  final String lessonLabel;
  final _LessonBrief? nextLesson;

  _LearningCourse({
    required this.courseRef,
    required this.courseName,
    required this.courseImage,
    required this.totalLessons,
    required this.completedCount,
    required this.progressValue,
    required this.isCompleted,
    required this.lessonLabel,
    required this.nextLesson,
  });
}

class _LessonBrief {
  final String id;
  final String name;
  final int order;
  final String description;
  final String videoUrl;
  final String thumbnail;

  _LessonBrief({
    required this.id,
    required this.name,
    required this.order,
    required this.description,
    required this.videoUrl,
    required this.thumbnail,
  });

  factory _LessonBrief.fromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return _LessonBrief(
      id: doc.id,
      name: data['lessonname']?.toString() ?? 'Lesson',
      order: int.tryParse(data['order']?.toString() ?? '') ?? 1,
      description: data['lessondescription']?.toString() ?? '',
      videoUrl: data['videoUrl']?.toString() ?? '',
      thumbnail: data['thumbnail']?.toString() ?? '',
    );
  }
}
