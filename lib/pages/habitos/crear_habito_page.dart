import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../layouts/app_layout.dart';

class CrearHabitoPage extends StatefulWidget {
  const CrearHabitoPage({super.key});

  @override
  State<CrearHabitoPage> createState() => _CrearHabitoPageState();
}

class _CrearHabitoPageState extends State<CrearHabitoPage> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String frecuencia = 'Diario';
  int duracion = 10;

  final List<String> opcionesFrecuencia = ['Diario', 'Semanal', 'Mensual'];

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentIndex: 2,
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Crear nuevo hábito ✍️',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nombre del hábito',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Este campo es requerido'
                  : null,
              onSaved: (value) => nombre = value ?? '',
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: frecuencia,
              decoration: const InputDecoration(
                labelText: 'Frecuencia',
                border: OutlineInputBorder(),
              ),
              items: opcionesFrecuencia
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => frecuencia = value ?? 'Diario'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Duración (minutos)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              initialValue: duracion.toString(),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Requerido';
                final parsed = int.tryParse(value);
                if (parsed == null || parsed <= 0)
                  return 'Ingresa un número válido';
                return null;
              },
              onSaved: (value) => duracion = int.parse(value ?? '10'),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  try {
                    await FirebaseFirestore.instance.collection('habitos').add({
                      'nombre': nombre,
                      'frecuencia': frecuencia,
                      'duracion': duracion,
                      'creadoEn': Timestamp.now(),
                      'icono': Icons.flag.codePoint,
                      'color': Colors.teal.value
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('✅ Hábito "$nombre" guardado con éxito')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('❌ Error al guardar: $e')),
                    );
                  }
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Guardar hábito'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
