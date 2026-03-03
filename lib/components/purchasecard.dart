import 'package:flutter/material.dart';

class Purchasecard extends StatelessWidget {
  final String image;
  final String title;
  final String purchaseddate;
  final String price;
  final String bill;

  const Purchasecard({
    super.key,
    required this.image,
    required this.title,
    required this.purchaseddate,
    required this.price,
    this.bill = "INVOICE",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E36),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // LEFT IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 14),

          // RIGHT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                // PURCHASE DATE
                Text(
                  "Purchased: $purchaseddate",
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // PRICE
                    Text(
                      price,
                      style: const TextStyle(
                        color: Color(0xFF1338F8),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // INVOICE BUTTON
                    Row(
                      children: [
                        const Icon(
                          Icons.download,
                          color: Colors.white54,
                          size: 12,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          bill,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
