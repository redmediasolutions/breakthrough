import 'package:cloud_firestore/cloud_firestore.dart';

class Coursesmodel {

  // CORE VALUES
  final String coursename;
  final String coursedescription;
  final String courseimage;
  final String courseprice;
  final bool isPublished;
  final String instructorID; 


  // SYSTEM VALUES
  final Timestamp createdAt;
  final Timestamp lastUpdated;

  // Analytics 
  final int userssignedup;

  Coursesmodel({
    required this.coursename,
    required this.coursedescription,
    required this.courseimage,
    required this.courseprice,
    required this.createdAt,
    required this.lastUpdated,
    required this.userssignedup,
    required this.isPublished,
    required this.instructorID, 
  });

  factory Coursesmodel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  return Coursesmodel(
    coursename: data['coursename'] ?? '',
    coursedescription: data['coursedescription'] ?? '',
    courseimage: data['courseimage'] ?? '',
    courseprice: data['courseprice'] ?? '',
    createdAt: data['createdAt'],
    lastUpdated: data['lastUpdated'],
    userssignedup: data['userssignedup'] ?? 0,
    isPublished: data['isPublished'] ?? false,
    instructorID: data['instructorID'] ?? '', 
  );
}
}