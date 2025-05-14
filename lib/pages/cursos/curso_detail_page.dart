import 'package:flutter/material.dart';
import '../../layouts/app_layout.dart';

class CursoDetailPage extends StatelessWidget {
  final String titulo;
  const CursoDetailPage({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    final lecciones = [
      {'titulo': 'Introducción', 'completado': true},
      {'titulo': 'Lección 1: Fundamentos', 'completado': true},
      {'titulo': 'Lección 2: Técnicas básicas', 'completado': false},
      {'titulo': 'Lección 3: Práctica guiada', 'completado': false},
    ];

    final leccionesCompletadas =
        lecciones.where((l) => l['completado'] == true).length;
    final progreso = leccionesCompletadas / lecciones.length;

    return AppLayout(
      currentIndex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progreso,
            minHeight: 10,
            color: Colors.teal,
            backgroundColor: Colors.teal.shade100,
          ),
          const SizedBox(height: 8),
          Text('${(progreso * 100).toStringAsFixed(0)}% completado'),
          const SizedBox(height: 20),
          const Text(
            'Lecciones 📚',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...lecciones.map((l) => ListTile(
                leading: Icon(
                  (l['completado'] as bool)
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: (l['completado'] as bool) ? Colors.green : Colors.grey,
                ),
                title: Text(l['titulo'] as String),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Acción futura: abrir la lección
                },
              )),
          const Spacer(),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // Acción futura: comenzar o continuar curso
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Continuar curso'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
