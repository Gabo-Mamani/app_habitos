import 'package:app_habitos/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../layouts/app_layout.dart';

class HabitosPage extends StatelessWidget {
  const HabitosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final habitos = [
      {
        'titulo': 'Leer 10 minutos',
        'icono': Icons.menu_book,
        'color': Colors.blue
      },
      {
        'titulo': 'Meditar 5 minutos',
        'icono': Icons.self_improvement,
        'color': Colors.green
      },
      {
        'titulo': 'Beber 2L de agua',
        'icono': Icons.local_drink,
        'color': Colors.teal
      },
      {
        'titulo': 'Ejercicio 15 min',
        'icono': Icons.fitness_center,
        'color': Colors.deepPurple
      },
    ];

    return AppLayout(
      currentIndex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tus hábitos sugeridos 🧠',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: habitos.length,
              itemBuilder: (context, index) {
                final habito = habitos[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: habito['color'] as Color,
                      child: Icon(habito['icono'] as IconData,
                          color: Colors.white),
                    ),
                    title: Text(habito['titulo'] as String),
                    trailing: const Icon(Icons.add_task_outlined),
                    onTap: () {
                      // Acción futura: iniciar o personalizar hábito
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(AppRoutes.crearHabito);
              },
              icon: const Icon(Icons.add),
              label: const Text('Crear hábito personalizado'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.teal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
