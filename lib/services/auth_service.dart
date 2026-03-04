import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Listen to Auth Changes (Tells the app if user is logged in or out)
  Stream<User?> get user => _auth.authStateChanges();

  // Login
  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get current User Data from Firestore
  Future<DocumentSnapshot> getUserData() async {
    return await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
  }
}