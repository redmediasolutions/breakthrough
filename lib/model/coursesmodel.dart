import 'package:cloud_firestore/cloud_firestore.dart';

class Coursesmodel {

  // CORE VALUES
  final String id;
  final String coursename;
  final String coursedescription;
  final String courseimage;
  final String courseprice;
  final bool isPublished;
  final String instructorID;
  final DocumentReference<Map<String, dynamic>>? instructorRef;

  // SYSTEM VALUES
  final Timestamp createdAt;
  final Timestamp lastUpdated;

  // Analytics
  final int userssignedup;

  Coursesmodel({
    required this.id,
    required this.coursename,
    required this.coursedescription,
    required this.courseimage,
    required this.courseprice,
    required this.createdAt,
    required this.lastUpdated,
    required this.userssignedup,
    required this.isPublished,
    required this.instructorID,
    this.instructorRef,
  });

  factory Coursesmodel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {

    final data = doc.data()!;

    String instructorId = '';
    DocumentReference<Map<String, dynamic>>? normalizedInstructorRef;

    final instructorField = data['instructorID'];

    if (instructorField is DocumentReference<Map<String, dynamic>>) {
      normalizedInstructorRef = instructorField;
      instructorId = instructorField.id;
    } else if (instructorField is DocumentReference) {
      normalizedInstructorRef = FirebaseFirestore.instance.doc(instructorField.path);
      instructorId = instructorField.id;
    } else if (instructorField is String) {
      final normalized = instructorField.startsWith('/')
          ? instructorField.substring(1)
          : instructorField;
      instructorId = normalized.contains('/') ? normalized.split('/').last : normalized;
    }

    return Coursesmodel(
      id: doc.id,
      coursename: data['coursename'] ?? '',
      coursedescription: data['coursedescription'] ?? '',
      courseimage: data['courseimage'] ?? '',
      courseprice: data['courseprice'] ?? '',
      createdAt: data['createdAt'],
      lastUpdated: data['lastUpdated'],
      userssignedup: data['userssignedup'] ?? 0,
      isPublished: data['isPublished'] ?? false,
      instructorID: instructorId,
      instructorRef: normalizedInstructorRef,
    );
  }
}
