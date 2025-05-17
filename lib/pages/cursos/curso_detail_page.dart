import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../layouts/app_layout.dart';

class CursoDetailPage extends StatelessWidget {
  final String cursoId;
  final String cursoNombre;

  const CursoDetailPage({
    super.key,
    required this.cursoId,
    required this.cursoNombre,
  });

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentIndex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cursoNombre,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Secciones del curso 📚',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cursos')
                  .doc(cursoId)
                  .collection('secciones')
                  .orderBy('orden')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final secciones = snapshot.data!.docs;

                if (secciones.isEmpty) {
                  return const Center(
                    child: Text('Aún no hay secciones en este curso.'),
                  );
                }

                return ListView.builder(
                  itemCount: secciones.length,
                  itemBuilder: (context, index) {
                    final data =
                        secciones[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.folder),
                        title: Text(data['nombre'] ?? 'Sin nombre'),
                        subtitle: Text('Orden: ${data['orden'] ?? '-'}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Get.toNamed('/lecciones', arguments: {
                            'cursoId': cursoId,
                            'seccionId': secciones[index].id,
                            'seccionNombre': data['nombre'],
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Get.toNamed('/crear-seccion', arguments: {
                  'cursoId': cursoId,
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Crear sección'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
