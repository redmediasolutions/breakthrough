import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CurriculumList extends StatelessWidget {
  final List<CurriculumItem> lessons;

  const CurriculumList({super.key, required this.lessons});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: lessons
          .map((lesson) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: CurriculumCard(item: lesson),
              ))
          .toList(),
    );
  }
}

class CurriculumItem {
  final String title;
  final String duration;
  final bool locked;
  final bool freepreview;

  CurriculumItem({
    required this.title,
    required this.duration,
    required this.locked,
    this.freepreview = false,
  });
}

class CurriculumCard extends StatelessWidget {
  final CurriculumItem item;

  const CurriculumCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textColor = item.locked ? Colors.white70 : Colors.white;

    return GestureDetector(
      onTap: () {
        context.pushNamed('lessonplayer');
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            child: Row(
              children: [
                buildicon(),
                const SizedBox(width: 12),
                buildtexts(textColor),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.white12,
          ),
        ],
      ),
    );
  }

  // ICON SECTION
  Widget buildicon() {
    return item.locked
        ? const Icon(Icons.lock, color: Colors.white38, size: 22)
        : Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1437EF),
            ),
            child: const Icon(Icons.play_arrow_rounded,
                color: Colors.white, size: 18),
          );
  }

  // TEXT SECTION
  Widget buildtexts(Color textColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                "Video • ${item.duration}",
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
              if (item.freepreview) ...[
                const SizedBox(width: 8),
                const Text(
                  "• Free Preview",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
