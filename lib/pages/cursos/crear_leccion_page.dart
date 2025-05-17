import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import '../../layouts/app_layout.dart';

class CrearLeccionPage extends StatefulWidget {
  final String cursoId;
  final String seccionId;

  const CrearLeccionPage({
    super.key,
    required this.cursoId,
    required this.seccionId,
  });

  @override
  State<CrearLeccionPage> createState() => _CrearLeccionPageState();
}

class _CrearLeccionPageState extends State<CrearLeccionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _ordenController = TextEditingController();
  final TextEditingController _campoTexto = TextEditingController();

  String _tipoSeleccionado = 'video_youtube';
  File? _archivoSeleccionado;
  String? _archivoNombre;

  Future<void> _seleccionarArchivo(FileType tipo,
      {List<String>? allowedExtensions}) async {
    final result = await FilePicker.platform.pickFiles(
      type: tipo,
      allowedExtensions: allowedExtensions,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _archivoSeleccionado = File(result.files.single.path!);
        _archivoNombre = path.basename(_archivoSeleccionado!.path);
      });
    }
  }

  Future<void> _guardarLeccion() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> contenido;

      switch (_tipoSeleccionado) {
        case 'video_youtube':
          contenido = {'url': _campoTexto.text.trim()};
          break;
        case 'video_subido':
        case 'teoria':
          contenido = {
            'archivo': _archivoNombre ?? 'archivo_local',
            'path_local': _archivoSeleccionado?.path ?? 'sin_path'
          };
          break;
        case 'reto':
          contenido = {
            'pregunta': _campoTexto.text.trim(),
            'opciones': ['Opción A', 'Opción B'],
            'respuesta_correcta': 'Opción A'
          };
          break;
        default:
          contenido = {'texto': _campoTexto.text.trim()};
      }

      final nuevaLeccion = {
        'titulo': _tituloController.text.trim(),
        'tipo': _tipoSeleccionado,
        'contenido': contenido,
        'orden': int.tryParse(_ordenController.text.trim()) ?? 0,
      };

      await FirebaseFirestore.instance
          .collection('cursos')
          .doc(widget.cursoId)
          .collection('secciones')
          .doc(widget.seccionId)
          .collection('lecciones')
          .add(nuevaLeccion);

      Get.back();
    }
  }

  Widget _campoDinamico() {
    switch (_tipoSeleccionado) {
      case 'video_youtube':
        return TextFormField(
          controller: _campoTexto,
          decoration: const InputDecoration(
            labelText: 'URL de YouTube',
            border: OutlineInputBorder(),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
        );
      case 'video_subido':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () => _seleccionarArchivo(FileType.video),
              icon: const Icon(Icons.video_file),
              label: const Text('Seleccionar video (.mp4)'),
            ),
            if (_archivoNombre != null) Text('📁 $_archivoNombre')
          ],
        );
      case 'teoria':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () => _seleccionarArchivo(
                FileType.custom,
                allowedExtensions: ['pdf'],
              ),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Seleccionar archivo PDF'),
            ),
            if (_archivoNombre != null) Text('📄 $_archivoNombre'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _campoTexto,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Texto explicativo (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        );
      case 'reto':
        return TextFormField(
          controller: _campoTexto,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Pregunta del reto',
            border: OutlineInputBorder(),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
        );
      default:
        return const SizedBox.shrink();
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
            const Text(
              'Nueva lección 📘',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título de la lección',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Este campo es obligatorio' : null,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _tipoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Tipo de lección',
                border: OutlineInputBorder(),
              ),
              items: [
                'video_youtube',
                'video_subido',
                'teoria',
                'reto',
              ]
                  .map((tipo) => DropdownMenuItem(
                        value: tipo,
                        child: Text(tipo),
                      ))
                  .toList(),
              onChanged: (valor) {
                setState(() {
                  _tipoSeleccionado = valor!;
                  _campoTexto.clear();
                  _archivoSeleccionado = null;
                  _archivoNombre = null;
                });
              },
            ),
            const SizedBox(height: 20),
            _campoDinamico(),
            const SizedBox(height: 20),
            TextFormField(
              controller: _ordenController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Orden',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Este campo es obligatorio' : null,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _guardarLeccion,
              icon: const Icon(Icons.save),
              label: const Text('Guardar lección'),
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
