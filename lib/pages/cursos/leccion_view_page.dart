import 'dart:io';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class LeccionViewPage extends StatefulWidget {
  final String tipo;
  final Map<String, dynamic> contenido;
  final String titulo;

  const LeccionViewPage({
    super.key,
    required this.tipo,
    required this.contenido,
    required this.titulo,
  });

  @override
  State<LeccionViewPage> createState() => _LeccionViewPageState();
}

class _LeccionViewPageState extends State<LeccionViewPage> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();

    if (widget.tipo == 'video_subido' &&
        widget.contenido['path_local'] != null) {
      _videoController =
          VideoPlayerController.file(File(widget.contenido['path_local']))
            ..initialize().then((_) {
              setState(() {});
              _videoController!.play();
            });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (widget.tipo) {
      case 'video_youtube':
        final videoId =
            YoutubePlayer.convertUrlToId(widget.contenido['url'] ?? '');
        content = YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoId ?? '',
            flags: const YoutubePlayerFlags(autoPlay: true),
          ),
          showVideoProgressIndicator: true,
        );
        break;

      case 'video_subido':
        content =
            _videoController != null && _videoController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : const Center(child: CircularProgressIndicator());
        break;

      case 'teoria':
        final path = widget.contenido['path_local'];
        if (path != null && path.toString().endsWith('.pdf')) {
          content = SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: PDFView(
              filePath: path,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
            ),
          );
        } else {
          content = Text(
            widget.contenido['texto'] ?? 'Sin contenido',
            style: const TextStyle(fontSize: 16),
          );
        }
        break;

      case 'reto':
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.contenido['pregunta'] ?? 'Sin pregunta',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...List<String>.from(widget.contenido['opciones'] ?? [])
                .map((opcion) {
              return ElevatedButton(
                onPressed: () {
                  final correcta = widget.contenido['respuesta_correcta'];
                  final esCorrecta = opcion == correcta;
                  final mensaje =
                      esCorrecta ? '¡Correcto! 🎉' : 'Incorrecto 😞';
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(mensaje),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cerrar'),
                        )
                      ],
                    ),
                  );
                },
                child: Text(opcion),
              );
            })
          ],
        );
        break;

      default:
        content = const Text('Tipo de lección no reconocido');
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: content,
      ),
    );
  }
}
