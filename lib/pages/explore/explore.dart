import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclearner/components/categorysign.dart';
import 'package:musiclearner/components/coursecards.dart';
import 'package:musiclearner/components/topinstructor.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F24),
        elevation: 0,
        centerTitle: true,

        leading: GestureDetector(
          onTap: () {
            context.pushNamed('profile');
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&auto=format&fit=crop&q=60",
              ),
            ),
          ),
        ),

        title: const Text(
          "Explore",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2140),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.notifications,
                  color: Colors.white, size: 22),
            ),
          ),
          
        ],
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
            // SEARCH BAR
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2140),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.white54, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            "Search instruments, artists, or skills",
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: const [
                  Category(icon: Icons.all_inbox, label: "All"),
                  SizedBox(width: 12),
                  Category(icon: Icons.piano, label: "Piano"),
                  SizedBox(width: 12),
                  Category(icon: Icons.mic, label: "Vocals"),
                  SizedBox(width: 12),
                  Category(icon: Icons.music_note, label: "Drums"),
                  SizedBox(width: 12),
                  Category(icon: Icons.music_note_sharp, label: "Guitar"),
                  SizedBox(width: 12),
                  Category(icon: Icons.headphones, label: "Production"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Trending Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "View All",
                    style: TextStyle(
                      color: Color(0xFF1437EF),
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: const [
                  Coursecards(
                    img: "https://media.istockphoto.com/id/1039281614/photo/young-boy-teaching-to-play-guitar.webp?a=1&b=1&s=612x612&w=0&k=20&c=3cJpKnrQAwRdUBsgiNLpoXUjuLbYyfCutF2Y0JRFpKc=",
                    lessons: "12 Lessons",
                    title: "Pro Mixing Secrets",
                    instructor: "David Miller",
                    price: "₹499",
                    oldPrice: "₹1,899",
                    rating: 4.9,
                  ),
                  SizedBox(width: 15),
                  Coursecards(
                    img: "https://media.istockphoto.com/id/1039281614/photo/young-boy-teaching-to-play-guitar.webp?a=1&b=1&s=612x612&w=0&k=20&c=3cJpKnrQAwRdUBsgiNLpoXUjuLbYyfCutF2Y0JRFpKc=",
                    lessons: "9 Lessons",
                    title: "Guitar Masterclass",
                    instructor: "Arjun Rao",
                    price: "₹699",
                    oldPrice: "₹2,499",
                    rating: 4.7,
                  ),
                  SizedBox(width: 15),
                  Coursecards(
                    img: "https://media.istockphoto.com/id/1039281614/photo/young-boy-teaching-to-play-guitar.webp?a=1&b=1&s=612x612&w=0&k=20&c=3cJpKnrQAwRdUBsgiNLpoXUjuLbYyfCutF2Y0JRFpKc=",
                    lessons: "15 Lessons",
                    title: "Piano Mastery",
                    instructor: "Sarah Jenkins",
                    price: "₹899",
                    oldPrice: "₹2,999",
                    rating: 4.8,
                  ),
                  SizedBox(width: 15),
                  Coursecards(
                    img: "https://media.istockphoto.com/id/1039281614/photo/young-boy-teaching-to-play-guitar.webp?a=1&b=1&s=612x612&w=0&k=20&c=3cJpKnrQAwRdUBsgiNLpoXUjuLbYyfCutF2Y0JRFpKc=",
                    lessons: "8 Lessons",
                    title: "Drumming Basics",
                    instructor: "Mike Portnoy",
                    price: "₹550",
                    oldPrice: "₹1,500",
                    rating: 4.6,
                  ),
                  SizedBox(width: 15),
                  Coursecards(
                    img: "https://media.istockphoto.com/id/1039281614/photo/young-boy-teaching-to-play-guitar.webp?a=1&b=1&s=612x612&w=0&k=20&c=3cJpKnrQAwRdUBsgiNLpoXUjuLbYyfCutF2Y0JRFpKc=",
                    lessons: "10 Lessons",
                    title: "Vocal Training",
                    instructor: "Emily Blunt",
                    price: "₹600",
                    oldPrice: "₹2,000",
                    rating: 4.8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Top Instructors",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "View All",
                    style: TextStyle(
                      color: Color(0xFF1437EF),
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: const [
                  Topinstructor(
                    img:
                        "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&q=60",
                    name: "Alex Johnson",
                    subtitle: "GUITAR",
                    rating: 4.9,
                  ),
                  SizedBox(width: 15),
                  Topinstructor(
                    img:
                        "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&q=60",
                    name: "Sarah Lee",
                    subtitle: "PIANO",
                    rating: 4.8,
                  ),
                  SizedBox(width: 15),
                  Topinstructor(
                    img:
                        "https://images.unsplash.com/photo-1521119989659-a83eee488004?w=500&q=60",
                    name: "David Chen",
                    subtitle: "DRUMS",
                    rating: 4.7,
                  ),
                  SizedBox(width: 15),
                  Topinstructor(
                    img:
                        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&q=60",
                    name: "Emily Rose",
                    subtitle: "VOCALS",
                    rating: 4.9,
                  ),
                ],
              ),
            )
            ],
          ),
        ),
      ),
    );
  }
}
