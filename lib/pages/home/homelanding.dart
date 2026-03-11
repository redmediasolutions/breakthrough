// ignore_for_file: deprecated_member_use

import 'package:breakthrough/cart/Cart_Page.dart';
import 'package:breakthrough/pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
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
    Coursesmodel course,
  ) {
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F24),
        elevation: 0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
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
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_checkout,
              color: Colors.white54,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
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
                      vertical: 10,
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
                        // 1. Remove the outer GestureDetector. It's cleaner to let the widget handle it.
                        child: Builder(
                          builder: (context) {
                            final instructorRef = _resolveInstructorRef(course);

                            // Create a reusable function for navigation to keep code clean
                            void navigateToDetails() {
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
                            }

                            if (instructorRef == null) {
                              return Coursecards(
                                img: course.courseimage,
                                lessons: "${course.userssignedup} Lessons",
                                title: course.coursename,
                                instructor: "Instructor",
                                price: "₹${course.courseprice}",
                                icons: Icons.add,
                                onTap:
                                    navigateToDetails, // PASS THE FUNCTION HERE
                                onIconTap: () async{
                                    try {
              print('➡️ Add to cart clicked');

             
             
              final user = FirebaseAuth.instance.currentUser;

              /// 🔐 Guest → show login
              if (user == null || user.isAnonymous) {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  enableDrag: false,
                  builder: (context) {
                    return Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: Login(),
                    );
                  },
                );
                return;
              }

             
         final String uid = user.uid;
    final String courseId = course.id; 

              final cartItemRef = FirebaseFirestore.instance
                  .collection('carts')
                  .doc(uid)
                  .collection('items')
                  .doc(courseId);

              final cartSnap = await cartItemRef.get();

         

              if (cartSnap.exists) {
                /// ➕ Increment
                await cartItemRef.update({
                  'quantity': FieldValue.increment(1),
                  'updatedAt': FieldValue.serverTimestamp(),
                });
              } else {
                /// 🆕 Create
                await cartItemRef.set({
          'courseId': course.id,
          'image': course.courseimage,
          'name': course.coursename,
          'price': course.courseprice,
          'quantity': 1,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
              }

              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Added to cart')));
              }
            } catch (e, stack) {
              print('❌ Add to cart error: $e');
              print(stack);
            }
                                }
                              );
                            }

                            return StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>
                            >(
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

                                return Coursecards(
                                  img: course.courseimage,
                                  lessons: "${course.userssignedup} Lessons",
                                  title: course.coursename,
                                  instructor: instructorName,
                                  price: "₹${course.courseprice}",
                                  icons: Icons.add,
                                  onTap:
                                      navigateToDetails, // PASS THE FUNCTION HERE
                                 onIconTap: () => _handleAddToCart(context, course)
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
                              final instructorRef = _resolveInstructorRef(
                                course,
                              );
                              if (instructorRef == null) {
                                return SmallCourseCard(
                                  img: course.courseimage,
                                  title: course.coursename,
                                  instructor: "Instructor",
                                  price: "₹${course.courseprice}",
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
                                );
                              }

                              return StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>
                              >(
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

                                  return SmallCourseCard(
                                    img: course.courseimage,
                                    title: course.coursename,
                                    instructor: instructorName,
                                    price: "₹${course.courseprice}",
                                    onTap: () {
                                      context.pushNamed(
                                        'coursedetails',
                                        extra: {
                                          'coursename': course.coursename,
                                          'courseId': course.id,
                                          'courseRef': FirebaseFirestore
                                              .instance
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
  Future<void> _handleAddToCart(BuildContext context, Coursesmodel course) async {
  try {
    print('➡️ Add to cart clicked: ${course.coursename}');
    final user = FirebaseAuth.instance.currentUser;

    // Guest → show login
    if (user == null || user.isAnonymous) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        builder: (context) => Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const Login(), // Ensure your Login widget is const if possible
        ),
      );
      return;
    }

    final String uid = user.uid;
    final String courseId = course.id;

    final cartItemRef = FirebaseFirestore.instance
        .collection('carts')
        .doc(uid)
        .collection('items')
        .doc(courseId);

    final cartSnap = await cartItemRef.get();

    if (cartSnap.exists) {
      await cartItemRef.update({
        'quantity': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await cartItemRef.set({
        'courseId': course.id,
        'image': course.courseimage,
        'name': course.coursename,
        'price': course.courseprice,
        'quantity': 1,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${course.coursename} added to cart')),
      );
    }
  } catch (e) {
    print('❌ Add to cart error: $e');
  }
}
}
