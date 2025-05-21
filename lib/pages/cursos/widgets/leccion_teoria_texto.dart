import 'package:flutter/material.dart';
import 'leccion_container.dart';

class LeccionTeoriaTexto extends StatelessWidget {
  final String titulo;
  final String texto;

  const LeccionTeoriaTexto({
    super.key,
    required this.titulo,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return LeccionContainer(
      titulo: titulo,
      icono: Icons.description,
      colorIcono: Colors.indigo,
      child: Text(
        texto,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              height: 1.6,
            ),
      ),
    );
  }
}
