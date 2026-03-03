// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Videoplayer extends StatefulWidget {
  final String videourl;
  final String thumbnailurl; 

  const Videoplayer({
    super.key,
    required this.videourl,
    required this.thumbnailurl,
  });

  @override
  State<Videoplayer> createState() => _VideoplayerState();
}

class _VideoplayerState extends State<Videoplayer> {
  late VideoPlayerController controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.network(widget.videourl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void togglePlay() {
    setState(() {
      if (controller.value.isPlaying) {
        controller.pause();
        isPlaying = false;
      } else {
        controller.play();
        isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: togglePlay,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: const Color(0xFF1C2037),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // VIDEO
            Positioned.fill(
              child: controller.value.isInitialized
                  ? VideoPlayer(controller)
                  : Image.network(
                      widget.thumbnailurl,
                      fit: BoxFit.cover,
                    ),
            ),

            // DARK 
            if (!isPlaying)
              Container(
                color: Colors.black.withOpacity(0.25),
              ),

            // PLAY BUTTON
            if (!isPlaying)
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1437EF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),

            // PREVIEW 
            if (!isPlaying)
              const Positioned(
                bottom: 14,
                right: 14,
                child: Text(
                  "PREVIEW",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
