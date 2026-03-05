import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String role; 
  final int phoneno; 

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneno,
    this.role = 'student', 
  });

  // Convert to Map for Firestore 
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneno': phoneno,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Create Model from Firestore 
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneno: _parsePhoneNumber(map['phoneno'] ?? map['phoneNo']),
      email: map['email'] ?? '',
      role: map['role'] ?? 'student',
    );
  }

  static int _parsePhoneNumber(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
