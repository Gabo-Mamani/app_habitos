import 'package:flutter/material.dart';
import 'widgets/leccion_video_youtube.dart';
import 'widgets/leccion_video_subido.dart';
import 'widgets/leccion_pdf.dart';
import 'widgets/leccion_teoria_texto.dart';
import 'widgets/leccion_reto.dart';

class LeccionViewPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final int numeroLeccion = contenido['orden'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lección ${numeroLeccion + 1}'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _renderLeccion(),
      ),
    );
  }

  Widget _renderLeccion() {
    final String? path = contenido['path_local'];
    final String? url = contenido['url'];
    final String? texto = contenido['texto'];
    final String? descripcion = contenido['descripcion'];
    final String? pregunta = contenido['pregunta'];
    final List<dynamic>? opciones = contenido['opciones'];
    final String? respuestaCorrecta = contenido['respuesta_correcta'];

    switch (tipo) {
      case 'video_youtube':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LeccionVideoYoutube(
              url: url ?? '',
              titulo: titulo,
            ),
            if ((descripcion ?? '').isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(descripcion!, style: const TextStyle(fontSize: 16)),
            ]
          ],
        );

      case 'video_subido':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LeccionVideoSubido(
              path: path ?? '',
            ),
            if ((descripcion ?? '').isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(descripcion!, style: const TextStyle(fontSize: 16)),
            ]
          ],
        );

      case 'teoria':
        if (path != null && path.endsWith('.pdf')) {
          return LeccionPdf(
            titulo: titulo,
            descripcion: descripcion ?? '',
            pathPdf: path,
          );
        } else {
          return LeccionTeoriaTexto(
            texto: texto ?? descripcion ?? 'Esta lección no contiene texto.',
            titulo: titulo,
          );
        }

      case 'reto':
        return LeccionReto(
          pregunta: pregunta ?? '',
          opciones: opciones ?? [],
          respuestaCorrecta: respuestaCorrecta ?? '',
          descripcion: descripcion,
        );

      default:
        return const Text('Tipo de lección no reconocido');
    }
  }
}
