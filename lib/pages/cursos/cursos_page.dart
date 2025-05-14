import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../layouts/app_layout.dart';

class CursosPage extends StatelessWidget {
  const CursosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cursos = [
      {'titulo': 'Guitarra', 'icono': Icons.music_note, 'color': Colors.orange},
      {'titulo': 'Inglés', 'icono': Icons.language, 'color': Colors.blue},
      {'titulo': 'Cocina', 'icono': Icons.restaurant_menu, 'color': Colors.red},
      {
        'titulo': 'Fotografía',
        'icono': Icons.camera_alt,
        'color': Colors.purple
      },
      {'titulo': 'Programación', 'icono': Icons.code, 'color': Colors.green},
    ];

    return AppLayout(
      currentIndex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cursos disponibles 🎓',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: cursos.length,
              itemBuilder: (context, index) {
                final curso = cursos[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: curso['color'] as Color,
                      child:
                          Icon(curso['icono'] as IconData, color: Colors.white),
                    ),
                    title: Text(curso['titulo'] as String),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Get.toNamed('/curso-detail', arguments: {
                        'titulo': curso['titulo'],
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
