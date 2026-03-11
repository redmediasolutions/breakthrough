import 'package:breakthrough/pages/home/homelanding.dart';
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

    double subtotal = 0;
    int totalQuantity = 0;
    double shipping = subtotal >= 500 ? 29.0 : 49.0;
    double taxRate = (subtotal + shipping) * 0.05;
   

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
            totalQuantity += qty;
          }

          double shipping = subtotal >= 500 ? 29.0 : 49.0;
          double taxRate = (subtotal + shipping) * 0.05;
          double total = subtotal + shipping + taxRate;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
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
                          final int currentQty = item['quantity'] ?? 1;

                          return _buildCartItem(
                            name: item['name'] ?? "Course",
                            price: "₹${item['price']}",
                            imageUrl: item['image'] ?? "",
                            quantity: currentQty,
                            onIncrement: () => _updateQuantity(
                              docId,
                              currentQty + 1,
                              user.uid,
                            ),
                            onDecrement: () => _updateQuantity(
                              docId,
                              currentQty - 1,
                              user.uid,
                            ),
                            onRemove: () => _removeItem(docId, user.uid),
                          );
                        },
                      ),

                      const Divider(thickness: 1, height: 40),
                      _buildSummaryRow("Subtotal","₹${subtotal.toStringAsFixed(2)}",
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow("Tax (5%)","₹${taxRate.toStringAsFixed(2)}",),
                      const SizedBox(height: 12),
                      _buildSummaryRow("Shipping","₹${shipping.toStringAsFixed(2)}",),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(thickness: 1),
                      ),
                      _buildSummaryRow("Total", "₹${total.toStringAsFixed(2)}", isTotal: true,),
                      const SizedBox(height: 30),
                      // Checkout button logic...
                    ],
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
            color: isTotal ? Colors.black : Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal ? const Color(0xFF1437EF) : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem({
    required String name,
    required String price,
    required String imageUrl,
    required int quantity,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
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
                          color: Colors.black,
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
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  price,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _quantityBtn(Icons.remove, onDecrement),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "$quantity",
                        style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.black),
                      ),
                    ),
                    _quantityBtn(Icons.add, onIncrement),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: Colors.black),
      ),
    );
  }

  // Helper to update quantity or remove item
  Future<void> _updateQuantity(
    String docId,
    int newQuantity,
    String userId,
  ) async {
    final docRef = FirebaseFirestore.instance
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(docId);

    if (newQuantity <= 0) {
      await docRef.delete();
    } else {
      await docRef.update({
        'quantity': newQuantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> _removeItem(String docId, String userId) async {
    await FirebaseFirestore.instance
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(docId)
        .delete();
  }
}
