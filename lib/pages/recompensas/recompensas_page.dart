import 'package:flutter/material.dart';
import '../../layouts/app_layout.dart';

class RecompensasPage extends StatelessWidget {
  const RecompensasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recompensas = [
      {
        'titulo': '¡Primer hábito!',
        'icono': Icons.star,
        'color': Colors.amber,
        'desbloqueado': true
      },
      {
        'titulo': '5 días seguidos',
        'icono': Icons.emoji_events,
        'color': Colors.orange,
        'desbloqueado': false
      },
      {
        'titulo': 'Curso completado',
        'icono': Icons.school,
        'color': Colors.green,
        'desbloqueado': false
      },
      {
        'titulo': '10 hábitos activos',
        'icono': Icons.bolt,
        'color': Colors.purple,
        'desbloqueado': false
      },
    ];

    return AppLayout(
      currentIndex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recompensas 🎁',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: recompensas.length,
              itemBuilder: (context, index) {
                final recompensa = recompensas[index];
                final desbloqueado = recompensa['desbloqueado'] as bool;
                return Opacity(
                  opacity: desbloqueado ? 1.0 : 0.4,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: recompensa['color'] as Color,
                        child: Icon(
                          recompensa['icono'] as IconData,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(recompensa['titulo'] as String),
                      trailing: Icon(
                        desbloqueado ? Icons.check_circle : Icons.lock_outline,
                        color: desbloqueado ? Colors.green : Colors.grey,
                      ),
                    ),
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
