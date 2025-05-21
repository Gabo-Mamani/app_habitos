import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LeccionVideoSubido extends StatefulWidget {
  final String path;

  const LeccionVideoSubido({
    super.key,
    required this.path,
  });

  @override
  State<LeccionVideoSubido> createState() => _LeccionVideoSubidoState();
}

class _LeccionVideoSubidoState extends State<LeccionVideoSubido> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: VideoPlayer(_controller!),
    );
  }
}
