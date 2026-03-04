// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:breakthrough/services/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final supabase = Supabase.instance.client;
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool isLogin = true;
  bool isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    final email = emailcontroller.text.trim();
    final password = passwordcontroller.text.trim();
    final messenger = ScaffoldMessenger.of(context);

    if (email.isEmpty || password.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Email and password are required'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
     await context.read<AuthProvider>().login(email, password);

    

      if (context.mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );
        context.goNamed('homelanding');
      }
    } on AuthException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101322),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Image.network(
                  'https://img.icons8.com/fluency/96/music.png',
                  height: 70,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Breakthrough\nAcademy",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Unlock your musical potential",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),

              Container(
                width: 400,
                alignment: Alignment.centerLeft,
                
                child: const Text(
                  "Email",
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 14),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 400,
                
                decoration: BoxDecoration(
                  
                  color: Color(0xFF1E2140),
                  borderRadius: BorderRadius.circular(12),
                
                ),
                child: TextField(
                  controller: emailcontroller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    hintText: "Enter Your Email",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 400,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Password",
                  style: TextStyle(color: Color.fromARGB(221, 255, 255, 255), fontSize: 14),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Color(0xFF1E2140),
                  borderRadius: BorderRadius.circular(12),
                  
                ),
                child: TextField(
                  controller: passwordcontroller,
                  obscureText: !_isPasswordVisible,
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (_) => _login(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    hintText: "Enter Your Password",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const SizedBox(width: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 50,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pushNamed('signuppage');
                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(
                        color: Color(0xFF1437EF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed('forgotpassword');
                    },
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Color(0xFF1437EF),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 400,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1437EF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: isLoading ? null : _login,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
              const SizedBox(height: 120),
              const Text(
                "Developed by Red Media Solutions",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
