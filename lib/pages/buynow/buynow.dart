import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclearner/components/buycoursecard.dart';
import 'package:musiclearner/components/ordersummary.dart';
import 'package:musiclearner/components/paymentmethod.dart';

class Buynow extends StatelessWidget {
  const Buynow({super.key});

  @override
  Widget build(BuildContext context) {
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



Buycoursecard(
  image: "https://i.imgur.com/BoN9kdC.png",
  category: "Music Course",
  title: "Advanced Guitar Techniques",
  instructor: "Rahul Sharma",
),

                  Text(
                    "Order Summary ",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
Ordersummary(
  courseprice: "₹423",
  tax: "₹76",
  totalamt: "₹499",
),
 const SizedBox(height: 10),
 Text(
                    "Payment Method ",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
  children: [
    Paymentmethod(
      icon: Icons.account_balance_wallet,
      title: "UPI Payments",
      subtitle: "Google Pay, PhonePe, Paytm",
    ),
    Paymentmethod(
      icon: Icons.credit_card,
      title: "Credit / Debit Cards",
      subtitle: "Visa, Mastercard, RuPay",
    ),
    Paymentmethod(
      icon: Icons.account_balance,
      title: "Net Banking",
      subtitle: "All major Indian banks",
    ),
  ],
),
// SECURE PAYMENT + FINAL AMOUNT
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 🔒 Secure Text
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

      SizedBox(height: 16),

      // Divider
      Container(
        height: 1,
        color: Colors.white10,
      ),

      SizedBox(height: 16),

      // Final Amount
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Final Amount",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "₹499",
            style: TextStyle(
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
const  SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed('homelanding');
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1437EF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
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
