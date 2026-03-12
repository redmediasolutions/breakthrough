import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breakthrough/components/purchasecard.dart';
import 'package:breakthrough/services/auth_provider.dart';

class Purchasehistory extends StatelessWidget {
  const Purchasehistory({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final userRef = user == null
        ? null
        : FirebaseFirestore.instance.collection('users').doc(user.uid);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101322),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: const Text(
          "My Purchase History",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, color: Colors.white, size: 20),
          ),
        ],
      ),
      body: userRef == null
          ? const Center(
              child: Text(
                "Please log in to view purchases.",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Enrollments')
                  .where('userRef', isEqualTo: userRef)
                  .where('status', isEqualTo: 'active')
                  .snapshots(),
              builder: (context, enrollSnap) {
                if (enrollSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!enrollSnap.hasData || enrollSnap.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No purchases yet.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                final enrollments = enrollSnap.data!.docs.toList();
                enrollments.sort((a, b) {
                  final aTime = a.data()['purchasedAt'];
                  final bTime = b.data()['purchasedAt'];
                  if (aTime is Timestamp && bTime is Timestamp) {
                    return bTime.compareTo(aTime);
                  }
                  return 0;
                });

                Future<double> computeTotal() async {
                  double total = 0;
                  for (final doc in enrollments) {
                    final data = doc.data();
                    final courseRef =
                        data['courseRef'] as DocumentReference<Map<String, dynamic>>?;
                    if (courseRef == null) continue;
                    final courseSnap = await courseRef.get();
                    final priceRaw =
                        courseSnap.data()?['courseprice']?.toString() ?? '0';
                    final digits = priceRaw.replaceAll(RegExp(r'[^0-9]'), '');
                    if (digits.isNotEmpty) {
                      total += double.tryParse(digits) ?? 0;
                    }
                  }
                  return total;
                }

                String formatDate(dynamic value) {
                  if (value is! Timestamp) return "Unknown";
                  final date = value.toDate();
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
                  final day = date.day.toString().padLeft(2, '0');
                  final month = months[date.month - 1];
                  return "$day $month ${date.year}";
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 22,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF3B4DFF),
                                Color(0xFF2C39C6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Total Invested",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  FutureBuilder<double>(
                                    future: computeTotal(),
                                    builder: (context, totalSnap) {
                                      final total = totalSnap.data ?? 0;
                                      final display = total.toStringAsFixed(0);
                                      return Text(
                                        "\u20B9$display",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Total Courses",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${enrollments.length}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Transactions",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...enrollments.map((doc) {
                        final data = doc.data();
                        final courseRef = data['courseRef']
                            as DocumentReference<Map<String, dynamic>>?;
                        final purchasedDate = formatDate(data['purchasedAt']);

                        if (courseRef == null) {
                          return const SizedBox.shrink();
                        }

                        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: courseRef.snapshots(),
                          builder: (context, courseSnap) {
                            if (!courseSnap.hasData ||
                                courseSnap.data?.data() == null) {
                              return const SizedBox.shrink();
                            }
                            final course = courseSnap.data!.data()!;
                            final title =
                                course['coursename']?.toString() ?? "Course";
                            final image = course['courseimage']?.toString() ??
                                "https://i.imgur.com/BoN9kdC.png";
                            final priceRaw =
                                course['courseprice']?.toString() ?? "0";

                            return Column(
                              children: [
                                Purchasecard(
                                  image: image,
                                  title: title,
                                  purchaseddate: purchasedDate,
                                  price: "\u20B9$priceRaw",
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          },
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
