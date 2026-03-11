// ignore_for_file: deprecated_member_use

import 'package:breakthrough/components/next_lesson.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:breakthrough/components/aboutinstructor.dart';
import 'package:breakthrough/components/videoplayer.dart';
import 'package:breakthrough/model/instructormodel.dart';
import 'package:breakthrough/model/lessonmodel.dart';
import 'package:breakthrough/services/auth_provider.dart';
import 'package:breakthrough/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Lessonplayer extends StatefulWidget {
  final Map<String, dynamic>? lessonData;

  const Lessonplayer({super.key, this.lessonData});

  @override
  State<Lessonplayer> createState() => _LessonplayerState();
}

class _LessonplayerState extends State<Lessonplayer> {
  bool _isSaving = false;

  Future<void> _markCompleted() async {
    final auth = context.read<AuthProvider>();
    final user = auth.user;
    if (user == null) {
      _showSnack("Please login to update progress.");
      return;
    }

    final lessonId = widget.lessonData?['lessonId']?.toString();
    final courseRef =
        widget.lessonData?['courseRef'] as DocumentReference<Map<String, dynamic>>?;

    if (lessonId == null || lessonId.isEmpty || courseRef == null) {
      _showSnack("Lesson info missing.");
      return;
    }

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    setState(() => _isSaving = true);
    try {
      await FirestoreService().markLessonCompleted(
        userRef: userRef,
        courseRef: courseRef,
        lessonId: lessonId,
      );
      if (!mounted) return;
      _showSnack("Marked as completed.");
    } catch (e) {
      if (!mounted) return;
      _showSnack("Failed to update progress: $e");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lessonName =
        widget.lessonData?['lessonName']?.toString() ?? "Lesson Player";
    final lessonDescription =
        widget.lessonData?['lessonDescription']?.toString() ??
            "No description available.";
    final videoUrl = widget.lessonData?['videoUrl']?.toString();
    final thumbnail = widget.lessonData?['thumbnail']?.toString();
    final courseRef =
        widget.lessonData?['courseRef'] as DocumentReference<Map<String, dynamic>>?;
    final currentLessonId = widget.lessonData?['lessonId']?.toString();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),

      appBar: AppBar(
        backgroundColor: const Color(0xFF101322),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,

        leading:  IconButton(
          onPressed: () {
            context.pop();
          },
           icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
        ),

        title:Text(
              lessonName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share, color: Colors.white, size: 20)

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
                videourl:
                    videoUrl ??
                    "https://www.mediafire.com/file/u707a7mmrhl6gzu/Export+Test.mov/file",
                thumbnailurl:
                    thumbnail ??
                    "https://plus.unsplash.com/premium_photo-1673804248447-5a405ff3ddbd?w=500",
              ),
            ),
             const SizedBox(height: 20),

            const SizedBox.shrink(),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _markCompleted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1437EF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Mark Completed",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),

            // INSTRUCTOR SECTION
            if (courseRef != null)
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: courseRef.snapshots(),
                builder: (context, courseSnap) {
                  if (courseSnap.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!courseSnap.hasData || courseSnap.data?.data() == null) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Instructor unavailable",
                        style: TextStyle(color: Colors.white60),
                      ),
                    );
                  }

                  final data = courseSnap.data!.data()!;
                  DocumentReference<Map<String, dynamic>>? instructorRef;
                  final dynamic refField = data['instructorRef'];
                  if (refField is DocumentReference<Map<String, dynamic>>) {
                    instructorRef = refField;
                  } else if (refField is DocumentReference) {
                    instructorRef =
                        FirebaseFirestore.instance.doc(refField.path);
                  } else {
                    final dynamic idField = data['instructorID'];
                    if (idField is DocumentReference<Map<String, dynamic>>) {
                      instructorRef = idField;
                    } else if (idField is DocumentReference) {
                      instructorRef =
                          FirebaseFirestore.instance.doc(idField.path);
                    } else if (idField is String && idField.trim().isNotEmpty) {
                      final raw = idField.trim();
                      final normalized =
                          raw.startsWith('/') ? raw.substring(1) : raw;
                      if (normalized.contains('/')) {
                        instructorRef =
                            FirebaseFirestore.instance.doc(normalized);
                      } else {
                        instructorRef = FirebaseFirestore.instance
                            .collection('instructors')
                            .doc(normalized);
                      }
                    }
                  }

                  if (instructorRef == null) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Instructor unavailable",
                        style: TextStyle(color: Colors.white60),
                      ),
                    );
                  }

                  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: instructorRef.snapshots(),
                    builder: (context, instructorSnap) {
                      if (instructorSnap.connectionState ==
                          ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!instructorSnap.hasData ||
                          instructorSnap.data?.data() == null) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Instructor unavailable",
                            style: TextStyle(color: Colors.white60),
                          ),
                        );
                      }

                      final instructor = InstructorModel.fromMap(
                        instructorSnap.data!.data()!,
                        instructorSnap.data!.id,
                      );

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
                  );
                },
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Instructor unavailable",
                  style: TextStyle(color: Colors.white60),
                ),
              ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                lessonDescription,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Colors.white12,
                thickness: 1,
              ),
            ),
            
            
            if (courseRef != null && currentLessonId != null)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Text(
                  "Up Next",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            if (courseRef != null && currentLessonId != null)
              StreamBuilder<List<LessonModel>>(
                stream: FirestoreService().listLessonsForCourse(courseRef),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final lessons = snapshot.data!;
                  final currentIndex = lessons
                      .indexWhere((lesson) => lesson.id == currentLessonId);
                  final nextIndex = currentIndex == -1
                      ? 0
                      : (currentIndex + 1 < lessons.length
                          ? currentIndex + 1
                          : -1);
                  if (nextIndex == -1) {
                    return const SizedBox.shrink();
                  }

                  final nextLesson = lessons[nextIndex];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: NextLessonCard(
                      lessonnumber: "Lesson ${nextIndex + 1}",
                      title: nextLesson.lessonname,
                      subtitle: nextLesson.isFreePreview
                          ? "Free Preview"
                          : "Locked",
                      duration: nextLesson.duration,
                      thumbnail: nextLesson.thumbnail.isNotEmpty
                          ? nextLesson.thumbnail
                          : "https://i.imgur.com/BoN9kdC.png",
                      islocked: !nextLesson.isFreePreview,
                      showDurationBadge: false,
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),




          ]
        ),
      ),
     // bottomNavigationBar: const Custombottomlesson(),
    );
  }
}

