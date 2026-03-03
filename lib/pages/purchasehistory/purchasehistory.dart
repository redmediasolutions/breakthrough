import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclearner/components/purchasecard.dart';


class Purchasehistory extends StatelessWidget {
  const Purchasehistory({super.key});

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
            icon: const Icon(Icons.filter_list, color: Colors.white, size: 20)

          ),
          ],
      ),

 body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
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

        // LEFT SIDE
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Total Invested",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "₹14,997",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        // RIGHT SIDE
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              "Total Courses",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "8",
              style: TextStyle(
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
SizedBox(height: 30),
Text(
              "Transactions",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
),
SizedBox(height: 20),

const Purchasecard(
  image: "https://i.imgur.com/BoN9kdC.png",
  title: "Advanced Music Theory & Composition",
  purchaseddate: "24 May 2024",
  price: "₹1,999",
),
SizedBox(height: 10),
const Purchasecard(
  image: "https://i.imgur.com/BoN9kdC.png",
  title: "Advanced Music Theory & Composition",
  purchaseddate: "24 May 2024",
  price: "₹1,999",
),
SizedBox(height: 10),
const Purchasecard(
  image: "https://i.imgur.com/BoN9kdC.png",
  title: "Advanced Music Theory & Composition",
  purchaseddate: "24 May 2024",
  price: "₹1,999",
),
SizedBox(height: 10),
const Purchasecard(
  image: "https://i.imgur.com/BoN9kdC.png",
  title: "Advanced Music Theory & Composition",
  purchaseddate: "24 May 2024",
  price: "₹1,999",
),
SizedBox(height: 10),
const Purchasecard(
  image: "https://i.imgur.com/BoN9kdC.png",
  title: "Advanced Music Theory & Composition",
  purchaseddate: "24 May 2024",
  price: "₹1,999",
),
SizedBox(height: 10),
const Purchasecard(
  image: "https://i.imgur.com/BoN9kdC.png",
  title: "Advanced Music Theory & Composition",
  purchaseddate: "24 May 2024",
  price: "₹1,999",
),


          ]
        ),
        ),



    );
  }
}