// ignore_for_file: deprecated_member_use

import 'package:breakthrough/components/next_lesson.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:breakthrough/components/aboutinstructor.dart';
import 'package:breakthrough/components/videoplayer.dart';
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
      _showSnack("Failed to update progress.");
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
    final videoUrl = widget.lessonData?['videoUrl']?.toString();
    final thumbnail = widget.lessonData?['thumbnail']?.toString();

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

            // TITLE & BESTSELLER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1437EF).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: Text(
                            "MODULE 3",
                            style: TextStyle(
                              color: Color(0xFF1437EF),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Lesson 4 of 12",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
            ),
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
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "In this lesson, we cover the fundamentals of the"
                  "minor pentatonic scale across the first position of"
                  "the fretboard. We'll focus on finger independence"
                  "and clarity of notes. ",
                style: TextStyle(
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
            
            
            Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
         child: Container(
    height: 45,
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: const Color(0xFF1E2140),
      borderRadius: BorderRadius.circular(14),
    ),


    child: Row(
      children: [
        // Resources
        Expanded(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),

            ),
            child: const Text(
              "Resources",
              style: TextStyle(
                color: Color(0xFF8A93BE),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Up Next
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0D0F24),
              borderRadius: BorderRadius.circular(12),

            ),
            alignment: Alignment.center,
            child: const Text(
              "Up Next",
              style: TextStyle(
                color: Color(0xFF8A93BE),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: NextLessonCard(
    lessonnumber: "Lesson 5",
    title: "Dynamic Alternate Picking Techniques",
    subtitle: "Advanced Speed Drills",
    duration: "08:14",
    thumbnail: "https://i.imgur.com/BoN9kdC.png",
    islocked: false,
  ),
),

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: NextLessonCard(
    lessonnumber: "Lesson 6",
    title: "Improvisation & Phrasing",
    subtitle: "The Art of Storytelling",
    duration: "15:30",
    thumbnail: "https://i.imgur.com/BoN9kdC.png",
    islocked: true,
  ),
),

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: NextLessonCard(
    lessonnumber: "Lesson 7",
    title: "Improvisation & Phrasing",
    subtitle: "The Art of Storytelling",
    duration: "15:30",
    thumbnail: "https://i.imgur.com/BoN9kdC.png",
    islocked: true,
  ),
),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: NextLessonCard(
    lessonnumber: "Lesson 7",
    title: "Improvisation & Phrasing",
    subtitle: "The Art of Storytelling",
    duration: "15:30",
    thumbnail: "https://i.imgur.com/BoN9kdC.png",
    islocked: true,
  ),
),
            const SizedBox(height: 20),




          ]
        ),
      ),
     // bottomNavigationBar: const Custombottomlesson(),
    );
  }
}
