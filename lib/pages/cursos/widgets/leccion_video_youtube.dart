import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LeccionVideoYoutube extends StatelessWidget {
  final String url;
  final String titulo;

  const LeccionVideoYoutube({
    super.key,
    required this.url,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayer.convertUrlToId(url);

    if (videoId == null) {
      return const Text('URL de YouTube no válida');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(autoPlay: false),
          ),
          showVideoProgressIndicator: true,
        ),
        const SizedBox(height: 20),
        Text(
          titulo,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
