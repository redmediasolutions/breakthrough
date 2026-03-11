import 'package:flutter/material.dart';

class Paymentmethod extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback? onTap;

  const Paymentmethod({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF101526),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF1437EF) : const Color(0xFF101526),
            width: 1.5,
          ),
        ),

        child: Row(
          children: [
            // ICON
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2140),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),

            const SizedBox(width: 16),

            // TITLE & SUBTITLE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? const Color(0xFF1437EF) : Colors.white38,
                  width: 2,
                ),
                color: selected ? const Color(0xFF1437EF) : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
