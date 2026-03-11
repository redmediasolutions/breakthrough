import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel {
  final String id;
  final DocumentReference<Map<String, dynamic>> courseRef;
  final String lessonname;
  final int order;
  final String duration;
  final String lessondescription;
  final String videoUrl;
  final String thumbnail;
  final bool isFreePreview;

  LessonModel({
    required this.id,
    required this.courseRef,
    required this.lessonname,
    required this.order,
    required this.duration,
    required this.lessondescription,
    required this.videoUrl,
    required this.thumbnail,
    required this.isFreePreview,
  });

  factory LessonModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final dynamic refField = data['courseRef'];
    final DocumentReference<Map<String, dynamic>> normalizedRef;
    if (refField is DocumentReference<Map<String, dynamic>>) {
      normalizedRef = refField;
    } else if (refField is DocumentReference) {
      normalizedRef = FirebaseFirestore.instance.doc(refField.path);
    } else if (refField is String) {
      final normalized =
          refField.startsWith('/') ? refField.substring(1) : refField;
      normalizedRef = FirebaseFirestore.instance.doc(normalized);
    } else {
      normalizedRef = FirebaseFirestore.instance.doc('Courses/unknown');
    }

    return LessonModel(
      id: doc.id,
      courseRef: normalizedRef,
      lessonname: data['lessonname'] ?? '',
      order: (data['order'] as num?)?.toInt() ?? 0,
      duration: data['duration']?.toString() ?? '',
      lessondescription: data['lessondescription']?.toString() ?? '',
      videoUrl: data['videoUrl']?.toString() ?? '',
      thumbnail: data['thumbnail']?.toString() ?? '',
      isFreePreview: data['isFreePreview'] ?? false,
    );
  }
}
