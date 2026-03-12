import 'package:breakthrough/components/buycoursecard.dart';
import 'package:breakthrough/components/ordersummary.dart';
import 'package:breakthrough/components/paymentmethod.dart';
import 'package:breakthrough/model/instructormodel.dart';
import 'package:breakthrough/services/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CheckoutItem {
  final String courseId;
  final String name;
  final String image;
  final double price;
  final int quantity;

  CheckoutItem({
    required this.courseId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });
}

class CheckoutPage extends StatefulWidget {
  final List<CheckoutItem> items;
  final bool fromCart;
  final Map<String, dynamic>? courseData;

  const CheckoutPage({
    super.key,
    required this.items,
    this.fromCart = false,
    this.courseData,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _isLoading = false;
  bool _upiSelected = true;

  DocumentReference<Map<String, dynamic>>? _resolveInstructorRef(
      DocumentReference<Map<String, dynamic>> courseRef,
      Map<String, dynamic> courseData) {
    final dynamic instructorRef = courseData['instructorRef'];
    if (instructorRef is DocumentReference<Map<String, dynamic>>) {
      return instructorRef;
    }
    if (instructorRef is DocumentReference) {
      return FirebaseFirestore.instance.doc(instructorRef.path);
    }

    final dynamic instructorIdField = courseData['instructorID'];
    if (instructorIdField is DocumentReference<Map<String, dynamic>>) {
      return instructorIdField;
    }
    if (instructorIdField is DocumentReference) {
      return FirebaseFirestore.instance.doc(instructorIdField.path);
    }
    if (instructorIdField is String && instructorIdField.trim().isNotEmpty) {
      final raw = instructorIdField.trim();
      final normalized = raw.startsWith('/') ? raw.substring(1) : raw;
      if (normalized.contains('/')) {
        return FirebaseFirestore.instance.doc(normalized);
      }
      return FirebaseFirestore.instance
          .collection('instructors')
          .doc(normalized);
    }

    return null;
  }

  double get _subtotal {
    double total = 0;
    for (final item in widget.items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  String _formatPrice(double value) {
    return "\u20B9${value.toStringAsFixed(0)}";
  }

  Future<void> _completePurchase() async {
    final auth = context.read<AuthProvider>();
    final user = auth.user;
    if (user == null) {
      _showSnack('Please login to complete purchase.');
      return;
    }

    if (widget.items.isEmpty) {
      _showSnack('No items to purchase.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final batch = FirebaseFirestore.instance.batch();

      for (final item in widget.items) {
        final courseRef = FirebaseFirestore.instance
            .collection('Courses')
            .doc(item.courseId);
        final enrollmentId = '${user.uid}_${courseRef.id}';
        final enrollmentRef = FirebaseFirestore.instance
            .collection('Enrollments')
            .doc(enrollmentId);

        batch.set(
          enrollmentRef,
          {
            'userRef': userRef,
            'courseRef': courseRef,
            'status': 'active',
            'purchasedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );

        if (widget.fromCart) {
          final cartItemRef = FirebaseFirestore.instance
              .collection('carts')
              .doc(user.uid)
              .collection('items')
              .doc(item.courseId);
          batch.delete(cartItemRef);
        }
      }

      await batch.commit();

      if (!mounted) return;
      final Map<String, dynamic> purchasedData = widget.courseData ?? {
        'coursename': widget.items.first.name,
        'courseimage': widget.items.first.image,
      };

      context.go('/purchased', extra: purchasedData);
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
    final totalText = _formatPrice(_subtotal);

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
            ...widget.items.map((item) {
              final courseRef = FirebaseFirestore.instance
                  .collection('Courses')
                  .doc(item.courseId);

              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: courseRef.snapshots(),
                builder: (context, courseSnap) {
                  final courseData = courseSnap.data?.data();
                  final instructorRef = courseData == null
                      ? null
                      : _resolveInstructorRef(courseRef, courseData);

                  final title = item.quantity > 1
                      ? '${item.name} x${item.quantity}'
                      : item.name;

                  if (instructorRef == null) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Buycoursecard(
                        image: item.image,
                        category: "Music Course",
                        title: title,
                        instructor: "Instructor",
                      ),
                    );
                  }

                  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Buycoursecard(
                          image: item.image,
                          category: "Music Course",
                          title: title,
                          instructor: instructorName,
                        ),
                      );
                    },
                  );
                },
              );
            }),
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
              courseprice: totalText,
              totalamt: totalText,
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
                        totalText,
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
