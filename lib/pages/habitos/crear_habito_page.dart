import 'package:flutter/material.dart';
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
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  // Aquí irá la lógica para guardar el hábito en Firebase u otra base
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('✅ Hábito "$nombre" guardado con éxito')),
                  );
                  Navigator.pop(context); // Volver a la vista anterior
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
