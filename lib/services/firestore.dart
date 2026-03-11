// ignore_for_file: avoid_print

import 'package:breakthrough/model/coursesmodel.dart';
import 'package:breakthrough/model/enrollmentmodel.dart';
import 'package:breakthrough/model/instructormodel.dart';
import 'package:breakthrough/model/lessonmodel.dart';
import 'package:breakthrough/model/progressmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  final CollectionReference<Map<String, dynamic>> coursecollection =
      FirebaseFirestore.instance.collection('Courses');

  Stream<List<Coursesmodel>> get listofCourses {

    return coursecollection
        .where('isPublished', isEqualTo: true)
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) {

        return Coursesmodel.fromFirestore(doc);

      }).toList();

    });

  }

  Stream<List<InstructorModel>> get listOfInstructors {
    return FirebaseFirestore.instance
        .collection('instructors')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => InstructorModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Stream<List<LessonModel>> listLessonsForCourse(
      DocumentReference<Map<String, dynamic>> courseRef) {
    return FirebaseFirestore.instance
        .collection('Lessons')
        .where('courseRef', isEqualTo: courseRef)
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(LessonModel.fromFirestore).toList();
    });
  }

  Stream<bool> isEnrolled({
    required DocumentReference<Map<String, dynamic>> userRef,
    required DocumentReference<Map<String, dynamic>> courseRef,
  }) {
    return FirebaseFirestore.instance
        .collection('Enrollments')
        .where('userRef', isEqualTo: userRef)
        .where('courseRef', isEqualTo: courseRef)
        .where('status', isEqualTo: 'active')
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  Stream<ProgressModel?> progressForCourse({
    required DocumentReference<Map<String, dynamic>> userRef,
    required DocumentReference<Map<String, dynamic>> courseRef,
  }) {
    return FirebaseFirestore.instance
        .collection('Progress')
        .where('userRef', isEqualTo: userRef)
        .where('courseRef', isEqualTo: courseRef)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return ProgressModel.fromFirestore(snapshot.docs.first);
    });
  }

  Future<void> markLessonCompleted({
    required DocumentReference<Map<String, dynamic>> userRef,
    required DocumentReference<Map<String, dynamic>> courseRef,
    required String lessonId,
  }) async {
    final progressQuery = await FirebaseFirestore.instance
        .collection('Progress')
        .where('userRef', isEqualTo: userRef)
        .where('courseRef', isEqualTo: courseRef)
        .limit(1)
        .get();

    final data = {
      'userRef': userRef,
      'courseRef': courseRef,
      'completedLessonIds': FieldValue.arrayUnion([lessonId]),
      'lastLessonId': lessonId,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (progressQuery.docs.isEmpty) {
      await FirebaseFirestore.instance
          .collection('Progress')
          .add(data);
    } else {
      await progressQuery.docs.first.reference.set(
        data,
        SetOptions(merge: true),
      );
    }
  }

}
