import 'package:app_habitos/pages/cursos/leccion_view_page.dart';
import 'package:app_habitos/pages/cursos/editar_leccion_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../layouts/app_layout.dart';

class LeccionesPage extends StatelessWidget {
  final String cursoId;
  final String seccionId;
  final String seccionNombre;

  const LeccionesPage({
    super.key,
    required this.cursoId,
    required this.seccionId,
    required this.seccionNombre,
  });

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentIndex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            seccionNombre,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Lecciones 📘',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              Get.toNamed('/crear-leccion', arguments: {
                'cursoId': cursoId,
                'seccionId': seccionId,
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Agregar lección'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cursos')
                  .doc(cursoId)
                  .collection('secciones')
                  .doc(seccionId)
                  .collection('lecciones')
                  .orderBy('orden')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final lecciones = snapshot.data!.docs;

                if (lecciones.isEmpty) {
                  return const Center(child: Text('No hay lecciones aún.'));
                }

                return ListView.builder(
                  itemCount: lecciones.length,
                  itemBuilder: (context, index) {
                    final doc = lecciones[index];
                    final data = doc.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.play_circle),
                        title: Text(data['titulo'] ?? 'Sin título'),
                        subtitle: Text(
                            'Tipo: ${data['tipo'] ?? 'desconocido'} • Orden: ${data['orden'] ?? '-'}'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'ver') {
                              Get.to(() => LeccionViewPage(
                                    titulo: data['titulo'],
                                    tipo: data['tipo'],
                                    contenido: Map<String, dynamic>.from(data),
                                  ));
                            } else if (value == 'editar') {
                              Get.to(() => EditarLeccionPage(
                                    cursoId: cursoId,
                                    seccionId: seccionId,
                                    leccionId: doc.id,
                                    data: Map<String, dynamic>.from(
                                        doc.data() as Map<String, dynamic>),
                                  ));
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'ver',
                              child: Text('Ver'),
                            ),
                            PopupMenuItem(
                              value: 'editar',
                              child: Text('Editar'),
                            ),
                          ],
                        ),
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
