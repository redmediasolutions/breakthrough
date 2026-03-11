import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:breakthrough/components/buycoursecard.dart';
import 'package:breakthrough/components/ordersummary.dart';
import 'package:breakthrough/components/paymentmethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breakthrough/model/instructormodel.dart';
import 'package:provider/provider.dart';
import 'package:breakthrough/services/auth_provider.dart';

class Buynow extends StatefulWidget {
  final Map<String, dynamic>? courseData;

  const Buynow({super.key, this.courseData});

  @override
  State<Buynow> createState() => _BuynowState();
}

class _BuynowState extends State<Buynow> {
  bool _isLoading = false;
  bool _upiSelected = true;

  DocumentReference<Map<String, dynamic>>? _resolveCourseRef() {
    final data = widget.courseData;
    if (data == null) return null;

    final dynamic courseRef = data['courseRef'];
    if (courseRef is DocumentReference<Map<String, dynamic>>) {
      return courseRef;
    }
    if (courseRef is DocumentReference) {
      return FirebaseFirestore.instance.doc(courseRef.path);
    }
    if (courseRef is String && courseRef.trim().isNotEmpty) {
      final raw = courseRef.trim();
      final normalized = raw.startsWith('/') ? raw.substring(1) : raw;
      return FirebaseFirestore.instance.doc(normalized);
    }

    final courseId = data['courseId']?.toString();
    if (courseId != null && courseId.isNotEmpty) {
      return FirebaseFirestore.instance.collection('Courses').doc(courseId);
    }
    return null;
  }

  DocumentReference<Map<String, dynamic>>? _resolveInstructorRef() {
    final data = widget.courseData;
    if (data == null) return null;

    final dynamic instructorRef = data['instructorRef'];
    if (instructorRef is DocumentReference<Map<String, dynamic>>) {
      return instructorRef;
    }
    if (instructorRef is DocumentReference) {
      return FirebaseFirestore.instance.doc(instructorRef.path);
    }

    final dynamic instructorIdField = data['instructorID'];
    if (instructorIdField is String && instructorIdField.trim().isNotEmpty) {
      final raw = instructorIdField.trim();
      final normalized = raw.startsWith('/') ? raw.substring(1) : raw;
      if (normalized.contains('/')) {
        return FirebaseFirestore.instance.doc(normalized);
      }
      return FirebaseFirestore.instance.collection('instructors').doc(normalized);
    }

    return null;
  }

  Future<void> _completePurchase() async {
    final auth = context.read<AuthProvider>();
    final user = auth.user;
    if (user == null) {
      _showSnack('Please login to complete purchase.');
      return;
    }

    final courseRef = _resolveCourseRef();
    if (courseRef == null) {
      _showSnack('Course info missing.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final enrollmentId = '${user.uid}_${courseRef.id}';
      await FirebaseFirestore.instance
          .collection('Enrollments')
          .doc(enrollmentId)
          .set({
        'userRef': userRef,
        'courseRef': courseRef,
        'status': 'active',
        'purchasedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;
      context.go('/purchased', extra: widget.courseData);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Purchase failed.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.courseData;
    final rawPrice = data?['courseprice']?.toString() ?? '0';
    final cleanedPrice = rawPrice
        .replaceAll('?', '')
        .replaceAll('₹', '')
        .replaceAll('?', '')
        .trim();
    final priceText = '\u20B9$cleanedPrice';
    final courseName = data?['coursename']?.toString() ?? "Course";
    final courseImage = data?['courseimage']?.toString() ??
        "https://i.imgur.com/BoN9kdC.png";
    final instructorRef = _resolveInstructorRef();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),

      appBar: AppBar(
        backgroundColor: const Color(0xFF101322),
        elevation: 0,
        automaticallyImplyLeading: false,
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
          "Checkout",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 1.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (instructorRef == null)
              Buycoursecard(
                image: courseImage,
                category: "Music Course",
                title: courseName,
                instructor: "Instructor",
              )
            else
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: instructorRef.snapshots(),
                builder: (context, snapshot) {
                  String instructorName = "Instructor";
                  if (snapshot.hasData && snapshot.data?.data() != null) {
                    final instructor = InstructorModel.fromMap(
                      snapshot.data!.data()!,
                      snapshot.data!.id,
                    );
                    instructorName = instructor.name.isNotEmpty
                        ? instructor.name
                        : instructorName;
                  }
                  return Buycoursecard(
                    image: courseImage,
                    category: "Music Course",
                    title: courseName,
                    instructor: instructorName,
                  );
                },
              ),

            const Text(
              "Order Summary ",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Ordersummary(
              courseprice: priceText,
              totalamt: priceText,
            ),
            const SizedBox(height: 12),
            const Text(
              "Payment Method ",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Paymentmethod(
              icon: Icons.account_balance_wallet,
              title: "UPI Payments",
              subtitle: "Google Pay, PhonePe, Paytm",
              selected: _upiSelected,
              onTap: () => setState(() => _upiSelected = true),
            ),

            // SECURE PAYMENT + FINAL AMOUNT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.lock, color: Colors.white38, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "SECURE 256-BIT SSL ENCRYPTED PAYMENT",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Container(
                    height: 1,
                    color: Colors.white10,
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Final Amount",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        priceText,
                        style: const TextStyle(
                          color: Color(0xFF1437EF),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _completePurchase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1437EF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Complete Purchase",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
