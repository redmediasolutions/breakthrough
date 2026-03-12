import 'package:breakthrough/pages/checkout/checkout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Buynow extends StatelessWidget {
  final Map<String, dynamic>? courseData;

  const Buynow({super.key, this.courseData});

  @override
  Widget build(BuildContext context) {
    final data = courseData ?? {};
    final courseId = data['courseId']?.toString() ??
        (data['courseRef'] is DocumentReference
            ? (data['courseRef'] as DocumentReference).id
            : '');
    final rawPrice = data['courseprice']?.toString() ?? '0';
    final cleaned = rawPrice
        .replaceAll('?', '')
        .replaceAll('₹', '')
        .replaceAll('?', '')
        .trim();
    final price = double.tryParse(cleaned) ?? 0;

    final item = CheckoutItem(
      courseId: courseId,
      name: data['coursename']?.toString() ?? 'Course',
      image: data['courseimage']?.toString() ??
          'https://i.imgur.com/BoN9kdC.png',
      price: price,
      quantity: 1,
    );

    return CheckoutPage(
      items: [item],
      fromCart: false,
      courseData: courseData,
    );
  }
}
