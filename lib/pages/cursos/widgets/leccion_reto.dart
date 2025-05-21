import 'package:flutter/material.dart';

class LeccionReto extends StatefulWidget {
  final String pregunta;
  final List<dynamic> opciones;
  final String respuestaCorrecta;
  final String? descripcion;

  const LeccionReto({
    super.key,
    required this.pregunta,
    required this.opciones,
    required this.respuestaCorrecta,
    this.descripcion,
  });

  @override
  State<LeccionReto> createState() => _LeccionRetoState();
}

class _LeccionRetoState extends State<LeccionReto> {
  int? seleccionIndex;
  bool respondido = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.pregunta,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...List.generate(widget.opciones.length, (index) {
          final opcion = widget.opciones[index];
          final esCorrecto = opcion == widget.respuestaCorrecta;
          final esSeleccionado = seleccionIndex == index;

          Color color = Colors.indigo;
          if (respondido && esSeleccionado && esCorrecto) {
            color = Colors.green;
          } else if (respondido && esSeleccionado && !esCorrecto) {
            color = Colors.red;
          }

          Icon? icono;
          if (respondido && esSeleccionado) {
            icono = esCorrecto
                ? const Icon(Icons.check, color: Colors.white)
                : const Icon(Icons.close, color: Colors.white);
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ElevatedButton.icon(
              icon: icono ?? const SizedBox.shrink(),
              label: Text(
                opcion,
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: respondido
                  ? null
                  : () {
                      setState(() {
                        seleccionIndex = index;
                        respondido = true;
                      });

                      final mensaje =
                          esCorrecto ? '¡Correcto! 🎉' : 'Incorrecto 😞';
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(mensaje),
                          content: esCorrecto
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green, size: 48)
                              : const Icon(Icons.close,
                                  color: Colors.red, size: 48),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cerrar'),
                            )
                          ],
                        ),
                      );
                    },
            ),
          );
        }),
        if (widget.descripcion != null &&
            widget.descripcion!.trim().isNotEmpty &&
            respondido) ...[
          const SizedBox(height: 24),
          const Text(
            'Explicación:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(widget.descripcion!),
        ]
      ],
    );
  }
}
