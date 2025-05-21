import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class FullscreenPdf extends StatelessWidget {
  final String path;

  const FullscreenPdf({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vista completa')),
      body: PDFView(
        filePath: path,
        autoSpacing: true,
        swipeHorizontal: true,
      ),
    );
  }
}
