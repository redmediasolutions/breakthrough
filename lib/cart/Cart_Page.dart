// ignore_for_file: file_names

import 'package:breakthrough/pages/home/homelanding.dart';
import 'package:breakthrough/pages/checkout/checkout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // In a real app, these would come from a Provider, Bloc, or a List

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // 1. Check if user is logged in
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Please login to see your cart",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F24),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Homelanding()),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.white54,
        ),
        title: const Text("Cart", style: TextStyle(color: Colors.white)),
      ),
//============== STREAM BUILDER TO FETCH CART ITEMS ============================//
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('carts')
            .doc(user.uid)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(color: Colors.white),
              ),
            );
          }


          final cartDocs = snapshot.data!.docs;

          double subtotal = 0;
          final checkoutItems = <CheckoutItem>[];

          for (var doc in cartDocs) {
            final data = doc.data() as Map<String, dynamic>;
            final int qty = data['quantity'] is int ? data['quantity'] : 1;
            double price = 0.0;
            if (data['price'] is num) {
              price = (data['price'] as num).toDouble();
            } else if (data['price'] is String) {
              price = double.tryParse(data['price']) ?? 0.0;
            }
            subtotal += (price * qty);
            
            checkoutItems.add(
              CheckoutItem(
                courseId: data['courseId']?.toString() ?? doc.id,
                name: data['name']?.toString() ?? "Course",
                image: data['image']?.toString() ?? "",
                price: price,
                quantity: qty,
              ),
            );
          }

          double total = subtotal;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Your Cart",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartDocs.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final doc = cartDocs[index];
                    final item = doc.data() as Map<String, dynamic>;
                    final String docId = doc.id;
                    return _buildCartItem(
                      name: item['name'] ?? "Course",
                      price: "\u20B9${item['price']}",
                      imageUrl: item['image'] ?? "",
                      onRemove: () => _removeItem(docId, user.uid),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  "Order Summary",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                _buildSummaryRow(
                  "Total",
                  "\u20B9${total.toStringAsFixed(2)}",
                  isTotal: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(
                            items: checkoutItems,
                            fromCart: true,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1437EF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Proceed to Checkout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //================ SUMMARY ROW WIDGET ===============================
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w400,
            color: isTotal ? Colors.white : Colors.white70,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal ? const Color(0xFF1437EF) : Colors.white,
          ),
        ),
      ],
    );
  }
//================ CART ITEM WIDGET ===============================//
  Widget _buildCartItem({
    required String name,
    required String price,
    required String imageUrl,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF141831),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E2140)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    GestureDetector(
                      onTap: onRemove,
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4D6FFF),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //================= REMOVE ITEM FUNCTION ===============================//
  Future<void> _removeItem(String docId, String userId) async {
    await FirebaseFirestore.instance
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(docId)
        .delete();
  }
}

