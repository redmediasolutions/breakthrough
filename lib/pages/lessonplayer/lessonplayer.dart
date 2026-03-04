// ignore_for_file: deprecated_member_use

import 'package:breakthrough/components/next_lesson.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:breakthrough/components/aboutinstructor.dart';
//import 'package:musiclearner/components/custombottomlesson.dart';
import 'package:breakthrough/components/videoplayer.dart';

class Lessonplayer extends StatelessWidget {
  const Lessonplayer({super.key});

  @override
  Widget build(BuildContext context) {
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
              "Lesson Player",
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Videoplayer(
                videourl:
                    "https://www.mediafire.com/file/u707a7mmrhl6gzu/Export+Test.mov/file",
                thumbnailurl:
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