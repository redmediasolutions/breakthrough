// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ShellLayout extends StatelessWidget {
  final Widget child;
  const ShellLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    int index = 0;
    if (location.startsWith('/explore')) index = 1;
    if (location.startsWith('/learning')) index = 2;
    if (location.startsWith('/profile')) index = 3;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1126),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            nav(context, Icons.home_rounded, "Home", 0, index),
            nav(context, Icons.explore_rounded, "Explore", 1, index),
            nav(context, Icons.school_rounded, "Learning", 2, index),
            nav(context, Icons.person_rounded, "Profile", 3, index),
          ],
        ),
      ),
    );
  }

  Widget nav(BuildContext context, IconData icon, String label, int itemIndex, int currentIndex) {
    bool selected = itemIndex == currentIndex;

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        if (itemIndex == 0) context.go('/home');
        if (itemIndex == 1) context.go('/explore');
        if (itemIndex == 2) context.go('/learning');
        if (itemIndex == 3) context.go('/profile');
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,
            color: selected ? const Color(0xFF4B6AFF) : Colors.white54,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? const Color(0xFF4B6AFF) : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}