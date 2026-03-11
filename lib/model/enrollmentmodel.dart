import 'package:cloud_firestore/cloud_firestore.dart';

class EnrollmentModel {
  final String id;
  final DocumentReference<Map<String, dynamic>> userRef;
  final DocumentReference<Map<String, dynamic>> courseRef;
  final String status;
  final Timestamp? purchasedAt;

  EnrollmentModel({
    required this.id,
    required this.userRef,
    required this.courseRef,
    required this.status,
    this.purchasedAt,
  });

  factory EnrollmentModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    final DocumentReference<Map<String, dynamic>> userRef =
        data['userRef'] is DocumentReference<Map<String, dynamic>>
            ? data['userRef']
            : FirebaseFirestore.instance.doc(data['userRef'].path);

    final DocumentReference<Map<String, dynamic>> courseRef =
        data['courseRef'] is DocumentReference<Map<String, dynamic>>
            ? data['courseRef']
            : FirebaseFirestore.instance.doc(data['courseRef'].path);

    return EnrollmentModel(
      id: doc.id,
      userRef: userRef,
      courseRef: courseRef,
      status: data['status']?.toString() ?? 'active',
      purchasedAt: data['purchasedAt'] as Timestamp?,
    );
  }
}
