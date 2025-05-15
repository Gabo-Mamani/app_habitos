import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../layouts/app_layout.dart';
import 'curso_detail_page.dart';

class CursosPage extends StatelessWidget {
  const CursosPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('cursos').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final cursos = snapshot.data!.docs;

                if (cursos.isEmpty) {
                  return const Center(
                      child: Text('No hay cursos disponibles.'));
                }

                return ListView.builder(
                  itemCount: cursos.length,
                  itemBuilder: (context, index) {
                    final curso = cursos[index].data() as Map<String, dynamic>;
                    final cursoId = cursos[index].id;

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(int.parse(
                              (curso['color'] ?? '#2196F3')
                                  .replaceAll('#', '0xff'))),
                          child: const Icon(Icons.school, color: Colors.white),
                        ),
                        title: Text(curso['nombre'] ?? 'Curso'),
                        subtitle: Text(curso['descripcion'] ?? ''),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Get.to(() => CursoDetailPage(
                                cursoId: cursoId,
                                cursoNombre: curso['nombre'],
                              ));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
