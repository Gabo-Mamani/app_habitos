import 'package:app_habitos/pages/cursos/widgets/fullscreen_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'leccion_container.dart';

class LeccionPdf extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String pathPdf;

  const LeccionPdf({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.pathPdf,
  });

  @override
  Widget build(BuildContext context) {
    return LeccionContainer(
      titulo: titulo,
      icono: Icons.picture_as_pdf,
      colorIcono: Colors.redAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            descripcion,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PDFView(
                    filePath: pathPdf,
                    autoSpacing: true,
                    swipeHorizontal: true,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.fullscreen),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => FullscreenPdf(path: pathPdf),
                    ));
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
