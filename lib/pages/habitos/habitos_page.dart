import 'package:app_habitos/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../layouts/app_layout.dart';

class HabitosPage extends StatefulWidget {
  const HabitosPage({super.key});

  @override
  State<HabitosPage> createState() => _HabitosPageState();
}

class _HabitosPageState extends State<HabitosPage> {
  final List<Map<String, dynamic>> habitosSugeridos = const [
    {
      'nombre': 'Leer 10 minutos',
      'frecuencia': 'Diario',
      'duracion': 10,
      'icono': Icons.menu_book,
      'color': Colors.blue
    },
    {
      'nombre': 'Meditar 5 minutos',
      'frecuencia': 'Diario',
      'duracion': 5,
      'icono': Icons.self_improvement,
      'color': Colors.green
    },
    {
      'nombre': 'Beber 2L de agua',
      'frecuencia': 'Diario',
      'duracion': 0,
      'icono': Icons.local_drink,
      'color': Colors.teal
    },
    {
      'nombre': 'Ejercicio 15 min',
      'frecuencia': 'Diario',
      'duracion': 15,
      'icono': Icons.fitness_center,
      'color': Colors.deepPurple
    },
  ];

  String fechaDeHoy() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  void mostrarDialogoEdicion(
      BuildContext context, String docId, Map<String, dynamic> data) {
    final formKey = GlobalKey<FormState>();
    String nombre = data['nombre'];
    String frecuencia = data['frecuencia'];
    String duracion = data['duracion'].toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar hábito'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: nombre,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  onSaved: (value) => nombre = value ?? '',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: frecuencia,
                  decoration: const InputDecoration(labelText: 'Frecuencia'),
                  onSaved: (value) => frecuencia = value ?? 'Diario',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: duracion,
                  decoration:
                      const InputDecoration(labelText: 'Duración (min)'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => duracion = value ?? '0',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();

                  await FirebaseFirestore.instance
                      .collection('habitos')
                      .doc(docId)
                      .update({
                    'nombre': nombre,
                    'frecuencia': frecuencia,
                    'duracion': int.tryParse(duracion) ?? 0,
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Hábito actualizado')),
                  );
                  setState(() {});
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> agregarHabitoSugerido(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: habitosSugeridos.map((habito) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: habito['color'],
                  child: Icon(habito['icono'], color: Colors.white),
                ),
                title: Text(habito['nombre']),
                subtitle: Text('Duración: ${habito['duracion']} min'),
                onTap: () async {
                  await FirebaseFirestore.instance.collection('habitos').add({
                    'nombre': habito['nombre'],
                    'frecuencia': habito['frecuencia'],
                    'duracion': habito['duracion'],
                    'creadoEn': Timestamp.now(),
                    'color': habito['color'].value,
                    'icono': habito['icono'].codePoint,
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('✅ Hábito "${habito['nombre']}" agregado.'),
                  ));

                  setState(() {});
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentIndex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tus hábitos personalizados 🧠',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('habitos')
                  .orderBy('creadoEn', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Aún no tienes hábitos guardados.'));
                }

                final habitos = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: habitos.length,
                  itemBuilder: (context, index) {
                    final data = habitos[index].data() as Map<String, dynamic>;

                    final color = data['color'] != null
                        ? Color(data['color'])
                        : Colors.teal;
                    final icon = data['icono'] != null
                        ? IconData(data['icono'], fontFamily: 'MaterialIcons')
                        : Icons.check_circle;

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color,
                          child: Icon(icon, color: Colors.white),
                        ),
                        title: Text(data['nombre'] ?? 'Sin nombre'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Frecuencia: ${data['frecuencia']}'),
                            if (data['duracion'] > 0)
                              Text('Duración: ${data['duracion']} min',
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black87)),
                          ],
                        ),
                        trailing: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('habitos')
                              .doc(habitos[index].id)
                              .collection('progreso')
                              .doc(fechaDeHoy())
                              .get(),
                          builder: (context, progresoSnap) {
                            final yaCompletado =
                                progresoSnap.data?.exists == true &&
                                    progresoSnap.data?['completado'] == true;

                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: yaCompletado
                                      ? 'Ya completado hoy'
                                      : 'Marcar como completado',
                                  icon: Icon(
                                    yaCompletado
                                        ? Icons.task_alt
                                        : Icons.task_alt_outlined,
                                    color: yaCompletado
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    final docRef = FirebaseFirestore.instance
                                        .collection('habitos')
                                        .doc(habitos[index].id)
                                        .collection('progreso')
                                        .doc(fechaDeHoy());

                                    if (yaCompletado) {
                                      await docRef.delete();
                                    } else {
                                      await docRef.set({
                                        'fecha': fechaDeHoy(),
                                        'completado': true,
                                      });
                                    }
                                    setState(() {});
                                  },
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'editar') {
                                      mostrarDialogoEdicion(
                                          context, habitos[index].id, data);
                                    } else if (value == 'eliminar') {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title:
                                              const Text('¿Eliminar hábito?'),
                                          content: Text(
                                              '¿Estás seguro de que deseas eliminar el hábito "${data['nombre']}"?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Cancelar')),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                              onPressed: () async {
                                                final messenger =
                                                    ScaffoldMessenger.of(
                                                        context);
                                                Navigator.pop(context);

                                                await FirebaseFirestore.instance
                                                    .collection('habitos')
                                                    .doc(habitos[index].id)
                                                    .delete();

                                                setState(() {});
                                                messenger.showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          '🗑 Hábito eliminado')),
                                                );
                                              },
                                              child: const Text('Eliminar'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                        value: 'editar',
                                        child: Text('✏️ Editar')),
                                    const PopupMenuItem(
                                        value: 'eliminar',
                                        child: Text('🗑 Eliminar')),
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(AppRoutes.crearHabito);
                },
                icon: const Icon(Icons.add),
                label: const Text('Crear hábito'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => agregarHabitoSugerido(context),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Agregar sugerido'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
