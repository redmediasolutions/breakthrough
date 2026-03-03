import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  // final AuthService _authService = AuthService();

  User? user;
  Map<String, dynamic>? profile;
  bool isLoading = false;

  AuthProvider() {
    // Authentication is removed, so we don't need to check auth state.
  }

  Future<void> loadUserProfile() async {
    // Does nothing as there is no user to load a profile for.
  }

  Future<void> login(String email, String password) async {
    // Does nothing as authentication is removed.
  }

  Future<void> logout() async {
    // Does nothing as authentication is removed.
  }

  bool get isLoggedIn => true;
}
