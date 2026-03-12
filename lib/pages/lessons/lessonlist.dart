import 'package:breakthrough/model/lessonmodel.dart';
import 'package:breakthrough/model/progressmodel.dart';
import 'package:breakthrough/services/auth_provider.dart';
import 'package:breakthrough/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LessonsListPage extends StatelessWidget {
  final Map<String, dynamic> courseData;

  const LessonsListPage({super.key, required this.courseData});

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
    final courseName =
        courseData['coursename']?.toString() ?? "Course Lessons";
    final courseRef = _resolveCourseRef();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101322),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: const Text(
          "Lessons",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: courseRef == null
          ? const Center(
              child: Text(
                "Lessons unavailable",
                style: TextStyle(color: Colors.white60),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "COURSE",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              courseName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2140),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "VIEW ALL",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _LessonsBody(courseRef: courseRef),
                ),
              ],
            ),
    );
  }
}

class _LessonsBody extends StatelessWidget {
  final DocumentReference<Map<String, dynamic>> courseRef;

  const _LessonsBody({required this.courseRef});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    if (user == null) {
      return const Center(
        child: Text(
          "Login to view lessons",
          style: TextStyle(color: Colors.white60),
        ),
      );
    }

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    return StreamBuilder<bool>(
      stream: FirestoreService().isEnrolled(
        userRef: userRef,
        courseRef: courseRef,
      ),
      builder: (context, enrolledSnap) {
        final isEnrolled = enrolledSnap.data ?? false;

        return StreamBuilder<ProgressModel?>(
          stream: FirestoreService().progressForCourse(
            userRef: userRef,
            courseRef: courseRef,
          ),
          builder: (context, progressSnap) {
            final completedIds =
                progressSnap.data?.completedLessonIds ?? <String>[];

            return StreamBuilder<List<LessonModel>>(
              stream: FirestoreService().listLessonsForCourse(courseRef),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Lessons error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.white60),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No lessons available",
                      style: TextStyle(color: Colors.white60),
                    ),
                  );
                }

                final lessons = snapshot.data!;
                return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: lessons.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    final prevCompleted = index == 0
                        ? true
                        : completedIds.contains(lessons[index - 1].id);
                    final unlockedByProgress = isEnrolled && prevCompleted;
                    final unlockedPreview =
                        !isEnrolled && lesson.isFreePreview && prevCompleted;
                    final locked = !(unlockedByProgress || unlockedPreview);
                    final completed = completedIds.contains(lesson.id);

                    return _LessonCard(
                      index: index + 1,
                      lesson: lesson,
                      locked: locked,
                      completed: completed,
                      onTap: locked
                          ? null
                          : () {
                              context.pushNamed(
                                'lessonplayer',
                                extra: {
                                  'lessonId': lesson.id,
                                  'lessonName': lesson.lessonname,
                                  'lessonDescription':
                                      lesson.lessondescription,
                                  'videoUrl': lesson.videoUrl,
                                  'thumbnail': lesson.thumbnail,
                                  'courseRef': courseRef,
                                },
                              );
                            },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class _LessonCard extends StatelessWidget {
  final int index;
  final LessonModel lesson;
  final bool locked;
  final bool completed;
  final VoidCallback? onTap;

  const _LessonCard({
    required this.index,
    required this.lesson,
    required this.locked,
    required this.completed,
    required this.onTap,
  });

  String _shortDescription(String text, {int maxChars = 45}) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return "Lesson overview";
    if (trimmed.length <= maxChars) return trimmed;
    return "${trimmed.substring(0, maxChars - 3)}...";
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = locked ? Colors.white60 : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF141831),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E2140)),
        ),
        child: Row(
          children: [
            _LessonIcon(locked: locked, completed: completed),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$index. ${lesson.lessonname}",
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 0.58,
                            child: Text(
                              _shortDescription(lesson.lessondescription),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Text(
                              "${lesson.duration} mins",
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (lesson.isFreePreview) ...[
                            const SizedBox(width: 6),
                            const Text(
                              "• Free Preview",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                          if (completed) ...[
                            const SizedBox(width: 6),
                            const Text(
                              "• Completed",
                              style: TextStyle(
                                color: Color(0xFF42C675),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${lesson.duration} mins",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      if (lesson.isFreePreview) ...[
                        const SizedBox(width: 8),
                        const Text(
                          "ï¿½ Free Preview",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      if (completed) ...[
                        const SizedBox(width: 8),
                        const Text(
                          "ï¿½ Completed",
                          style: TextStyle(
                            color: Color(0xFF42C675),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              locked ? Icons.lock : Icons.chevron_right,
              color: locked ? Colors.white24 : Colors.white38,
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonIcon extends StatelessWidget {
  final bool locked;
  final bool completed;

  const _LessonIcon({required this.locked, required this.completed});

  @override
  Widget build(BuildContext context) {
    if (completed) {
      return Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF1B403B),
        ),
        child: const Icon(Icons.check, color: Color(0xFF42C675), size: 18),
      );
    }
    if (locked) {
      return const Icon(Icons.lock, color: Colors.white38, size: 22);
    }
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF1437EF),
      ),
      child: const Icon(Icons.play_arrow_rounded,
          color: Colors.white, size: 20),
    );
  }
}

