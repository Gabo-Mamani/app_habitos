import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;

class EditarLeccionPage extends StatefulWidget {
  final String cursoId;
  final String seccionId;
  final String leccionId;
  final Map<String, dynamic> data;

  const EditarLeccionPage({
    super.key,
    required this.cursoId,
    required this.seccionId,
    required this.leccionId,
    required this.data,
  });

  @override
  State<EditarLeccionPage> createState() => _EditarLeccionPageState();
}

class _EditarLeccionPageState extends State<EditarLeccionPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _campoTexto;
  late TextEditingController _ordenController;

  String _tipoSeleccionado = 'teoria';
  File? _archivoSeleccionado;
  String? _archivoNombre;

  @override
  void initState() {
    super.initState();
    final d = widget.data;

    _tipoSeleccionado = d['tipo'] ?? 'teoria';
    _tituloController = TextEditingController(text: d['titulo'] ?? '');
    _campoTexto = TextEditingController(
      text: (d['descripcion'] ?? d['texto'] ?? d['url'] ?? d['pregunta'] ?? '')
          .toString(),
    );
    _ordenController =
        TextEditingController(text: (d['orden'] ?? 0).toString());
    _archivoNombre = d['archivo']?.toString();
  }

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

  Future<void> _actualizarLeccion() async {
    if (_formKey.currentState!.validate()) {
      final nuevoOrden = int.tryParse(_ordenController.text.trim()) ?? 0;

      final duplicados = await FirebaseFirestore.instance
          .collection('cursos')
          .doc(widget.cursoId)
          .collection('secciones')
          .doc(widget.seccionId)
          .collection('lecciones')
          .where('orden', isEqualTo: nuevoOrden)
          .get();

      final yaExiste = duplicados.docs.any((doc) => doc.id != widget.leccionId);

      if (yaExiste) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Ya existe otra lección con ese orden.')),
        );
        return;
      }

      final leccionActualizada = {
        'titulo': _tituloController.text.trim(),
        'tipo': _tipoSeleccionado,
        'orden': nuevoOrden,
      };

      switch (_tipoSeleccionado) {
        case 'video_youtube':
          leccionActualizada['url'] = _campoTexto.text.trim();
          break;
        case 'video_subido':
          if (_archivoNombre != null) {
            leccionActualizada['archivo'] = _archivoNombre!;
          }
          leccionActualizada['path_local'] =
              _archivoSeleccionado?.path ?? widget.data['path_local'];
          break;
        case 'teoria':
          if (_archivoNombre != null) {
            leccionActualizada['archivo'] = _archivoNombre!;
          }
          leccionActualizada['path_local'] =
              _archivoSeleccionado?.path ?? widget.data['path_local'];
          leccionActualizada['descripcion'] = _campoTexto.text.trim();
          break;
        case 'reto':
          leccionActualizada['pregunta'] = _campoTexto.text.trim();
          leccionActualizada['opciones'] = ['Opción A', 'Opción B'];
          leccionActualizada['respuesta_correcta'] = 'Opción A';
          break;
        default:
          leccionActualizada['texto'] = _campoTexto.text.trim();
      }

      await FirebaseFirestore.instance
          .collection('cursos')
          .doc(widget.cursoId)
          .collection('secciones')
          .doc(widget.seccionId)
          .collection('lecciones')
          .doc(widget.leccionId)
          .update(leccionActualizada);

      Get.back();
    }
  }

  Future<void> _eliminarLeccion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar lección?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await FirebaseFirestore.instance
          .collection('cursos')
          .doc(widget.cursoId)
          .collection('secciones')
          .doc(widget.seccionId)
          .collection('lecciones')
          .doc(widget.leccionId)
          .delete();

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
              label: const Text('Reemplazar video'),
            ),
            if (_archivoNombre != null) Text('📁 $_archivoNombre'),
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
              label: const Text('Reemplazar archivo PDF'),
            ),
            if (_archivoNombre != null) Text('📄 $_archivoNombre'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _campoTexto,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Texto explicativo',
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
    return Scaffold(
      appBar: AppBar(title: const Text('Editar lección')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título de la lección',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _tipoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Tipo de lección',
                border: OutlineInputBorder(),
              ),
              items: ['video_youtube', 'video_subido', 'teoria', 'reto']
                  .map((tipo) => DropdownMenuItem(
                        value: tipo,
                        child: Text(tipo),
                      ))
                  .toList(),
              onChanged: (valor) {
                setState(() {
                  _tipoSeleccionado = valor!;
                  _campoTexto.clear();
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
                  v == null || v.isEmpty ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _actualizarLeccion,
              icon: const Icon(Icons.save),
              label: const Text('Guardar cambios'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _eliminarLeccion,
              icon: const Icon(Icons.delete),
              label: const Text('Eliminar lección'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
