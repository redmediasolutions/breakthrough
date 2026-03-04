// ignore_for_file: avoid_print

import 'package:breakthrough/model/coursesmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class FirestoreService {
  final CollectionReference coursecollection = FirebaseFirestore.instance.collection('Courses');

  Stream<List<Coursesmodel>> get listofCourses {
    return coursecollection
        .where('isPublished', isEqualTo: true)
        .snapshots()
        .handleError(
          (error) => print("Error fetching courses: $error"),
        )
        .map((snapshot) =>
          snapshot.docs
              .map((doc) =>
                  Coursesmodel.fromFirestore(
                      doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList());
    }
  }