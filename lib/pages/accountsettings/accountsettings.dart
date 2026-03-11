// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breakthrough/services/auth_provider.dart';
import 'package:breakthrough/model/usermodel.dart';

class Accountsettings extends StatefulWidget {
  const Accountsettings({super.key});

  @override
  State<Accountsettings> createState() => _AccountsettingsState();
}

class _AccountsettingsState extends State<Accountsettings> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _didInit = false;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;

    final auth = context.read<AuthProvider>();
    final userData = auth.userData;
    if (userData != null) {
      _nameController.text = userData['fullName']?.toString() ?? '';
      _emailController.text = userData['email']?.toString() ?? '';
      final phoneValue =
          userData['phoneno'] ?? userData['phoneNo'] ?? userData['phone'];
      _phoneController.text = phoneValue?.toString() ?? '';
    } else if (auth.user != null) {
      _emailController.text = auth.user!.email ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final auth = context.read<AuthProvider>();
    final user = auth.user;
    if (user == null) {
      _showSnack("Please login to save changes.");
      return;
    }

    final fullName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phoneRaw = _phoneController.text.trim();
    final phoneNumber = int.tryParse(phoneRaw);

    if (fullName.isEmpty) {
      _showSnack("Full name is required.");
      return;
    }
    if (email.isEmpty) {
      _showSnack("Email is required.");
      return;
    }
    if (phoneNumber == null) {
      _showSnack("Enter a valid phone number.");
      return;
    }

    setState(() => _isSaving = true);
    try {
      final model = UserModel(
        uid: user.uid,
        fullName: fullName,
        email: email,
        phoneno: phoneNumber,
        role: (auth.userData?['role'] ?? 'student').toString(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(model.toMap(), SetOptions(merge: true));

      await auth.fetchUserData();

      if (!mounted) return;
      _showSnack("Profile updated successfully.");
    } catch (e) {
      if (!mounted) return;
      _showSnack("Failed to update profile.");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),

      appBar: AppBar(
        backgroundColor: const Color(0xFF101322),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading:  IconButton(
          onPressed: () {
            context.pop();
          },
           icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
        ),
        title:   Text(
              "Account Settings",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveChanges,
            child: const Text(
              "Save",
              style: TextStyle(
                color: Color(0xFF3C5BFF),
                fontWeight: FontWeight.bold,
              ),
            ), 
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
  padding: const EdgeInsets.symmetric(vertical: 20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
        Center(
  child: Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          // OUTER BLUE 
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 3,
                color: const Color(0xFF1437EF),
              ),
             
            ),
          ),

          // PROFILE IMAGE
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              image: const DecorationImage(
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&auto=format&fit=crop&q=60",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // EDIT OVERLAY
          Positioned(
            child: Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.45),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.camera_alt, color: Colors.white, size: 21),
                  SizedBox(height: 4),
                  Text(
                    "EDIT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),

      const Text(
        "Profile Picture",
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  ),
),

// PERSONAL INFORMATION
const Padding(
  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
  child: Text(
    "PERSONAL INFORMATION",
    style: TextStyle(
      color: Colors.white54,
      fontSize: 13,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    ),
  ),
),



// PERSONAL INFO 
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Container(
    decoration: BoxDecoration(
      color: Color(0xFF1A1E36),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [

        // FULL NAME
        _EditableField(
          label: "FULL NAME",
          controller: _nameController,
          keyboardType: TextInputType.name,
        ),

        const Divider(color: Colors.white12, height: 1, indent: 16, endIndent: 16),

        // EMAIL ADDRESS
        _EditableField(
          label: "EMAIL ADDRESS",
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),

        const Divider(color: Colors.white12, height: 1, indent: 16, endIndent: 16),

        // PHONE NUMBER
        _EditableField(
          label: "PHONE NUMBER",
          controller: _phoneController,
          keyboardType: TextInputType.phone,
        ),
      ],
    ),
  ),
),

const SizedBox(height: 28),

// SECURITY
const Padding(
  padding: EdgeInsets.symmetric(horizontal: 20),
  child: Text(
    "SECURITY",
    style: TextStyle(
      color: Colors.white54,
      fontSize: 13,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    ),
  ),
),


// SECURITY CARD
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
  child: Container(
    decoration: BoxDecoration(
      
      color: Color(0xFF1A1E36),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [

        // CHANGE PASSWORD
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.lock, color: Colors.white),
          ),
          title: const Text(
            "Change Password",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.white30),
          onTap: () => context.go('/forgot'),
        ),

        const Divider(color: Colors.white12, height: 1, indent: 16, endIndent: 16),

        // TWO-FACTOR AUTH
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.security, color: Colors.white),
          ),
          title: const Text(
            "Two-Factor Authentication",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "On",
                style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.white30),
            ],
          ),
        ),
      ],
    ),
  ),
),




    ],
  ),
      ),
          ],
        ),
      ),
    );
  }
}

class _EditableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _EditableField({
    required this.label,
    required this.controller,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
