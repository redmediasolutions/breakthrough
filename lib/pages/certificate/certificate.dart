// ignore_for_file: deprecated_member_use

import 'package:breakthrough/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CertificatePage extends StatelessWidget {
  final String courseName;
  final String courseImage;

  const CertificatePage({
    super.key,
    required this.courseName,
    required this.courseImage,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final fullName =
        auth.userData?['fullName']?.toString().trim().isNotEmpty == true
            ? auth.userData!['fullName'].toString().trim()
            : "Student";

    final now = DateTime.now();
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    final issuedDate =
        "${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]} ${now.year}";

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F24),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: const Text(
          "Certificate",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF141831),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1E2140)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1437EF).withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 12),
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1437EF).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "CERTIFICATE OF COMPLETION",
                      style: TextStyle(
                        color: Color(0xFF7FA0FF),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "has successfully completed",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    courseName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: DecorationImage(
                        image: NetworkImage(courseImage.isNotEmpty
                            ? courseImage
                            : "https://i.imgur.com/BoN9kdC.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Issued On",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            issuedDate,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1437EF).withOpacity(0.25),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF7FA0FF).withOpacity(0.7),
                          ),
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Color(0xFF7FA0FF),
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1E36),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1E2140)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.download_rounded, color: Color(0xFF7FA0FF)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Download Certificate",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.white38),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
