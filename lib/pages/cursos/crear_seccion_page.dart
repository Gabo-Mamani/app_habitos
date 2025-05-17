import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../layouts/app_layout.dart';

class CrearSeccionPage extends StatefulWidget {
  final String cursoId;

  const CrearSeccionPage({super.key, required this.cursoId});

  @override
  State<CrearSeccionPage> createState() => _CrearSeccionPageState();
}

class _CrearSeccionPageState extends State<CrearSeccionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _ordenController = TextEditingController();

  Future<void> _guardarSeccion() async {
    if (_formKey.currentState!.validate()) {
      final nuevaSeccion = {
        'nombre': _nombreController.text.trim(),
        'orden': int.tryParse(_ordenController.text.trim()) ?? 0,
      };

      await FirebaseFirestore.instance
          .collection('cursos')
          .doc(widget.cursoId)
          .collection('secciones')
          .add(nuevaSeccion);

      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentIndex: 1,
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Nueva sección',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la sección',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _ordenController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Orden',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _guardarSeccion,
              icon: const Icon(Icons.save),
              label: const Text('Guardar sección'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
