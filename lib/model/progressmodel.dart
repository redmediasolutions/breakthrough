import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressModel {
  final String id;
  final DocumentReference<Map<String, dynamic>> userRef;
  final DocumentReference<Map<String, dynamic>> courseRef;
  final List<String> completedLessonIds;
  final String? lastLessonId;
  final Timestamp? updatedAt;

  ProgressModel({
    required this.id,
    required this.userRef,
    required this.courseRef,
    required this.completedLessonIds,
    this.lastLessonId,
    this.updatedAt,
  });

  factory ProgressModel.fromFirestore(
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

    final completedRaw = data['completedLessonIds'];
    final completed = completedRaw is List
        ? completedRaw.map((e) => e.toString()).toList()
        : <String>[];

    return ProgressModel(
      id: doc.id,
      userRef: userRef,
      courseRef: courseRef,
      completedLessonIds: completed,
      lastLessonId: data['lastLessonId']?.toString(),
      updatedAt: data['updatedAt'] as Timestamp?,
    );
  }
}
