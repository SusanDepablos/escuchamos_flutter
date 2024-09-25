import 'dart:io';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(List<File>) onMediaChanged;

  const ImagePickerWidget({required this.onMediaChanged, Key? key}) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final List<File> _mediaFiles = [];
  final ImagePicker _picker = ImagePicker();

  // Método para seleccionar múltiples imágenes y videos
  Future<void> _pickMedia() async {
    // Mostrar un diálogo de selección para elegir entre imagen o video
    await showModalBottomSheet<XFile?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteapp,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(MaterialIcons.image),
                title: const Text('Imagen'),
                onTap: () async {
                  Navigator.pop(context); // Cerrar el modal
                  final List<XFile>? selectedFiles = await _picker.pickMultiImage();
                  if (selectedFiles != null) {
                    _addMediaFiles(selectedFiles);
                  }
                },
              ),
              ListTile(
                leading: const Icon(MaterialIcons.video),
                title: const Text('Video'),
                onTap: () async {
                  Navigator.pop(context); // Cerrar el modal
                  final XFile? videoFile = await _picker.pickVideo(source: ImageSource.gallery);
                  if (videoFile != null) {
                    _addMediaFiles([videoFile]); // Agregar el video
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Método para agregar archivos a la lista
  void _addMediaFiles(List<XFile> selectedFiles) {
    setState(() {
      for (var mediaFile in selectedFiles) {
        if (_mediaFiles.length < 9) {
          _mediaFiles.add(File(mediaFile.path));
        }
      }
      widget.onMediaChanged(_mediaFiles);
    });
  }

  // Método para eliminar un archivo seleccionado
  void _removeMedia(int index) {
    setState(() {
      _mediaFiles.removeAt(index);
      widget.onMediaChanged(_mediaFiles);
    });
  }

  // Método para construir la vista previa del video
  Widget _buildVideoPreview(File videoFile) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.black,
      ),
      child: const Icon(
        MaterialIcons.video,
        color: AppColors.whiteapp,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mostrar archivos seleccionados
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ..._mediaFiles.map((file) {
              int index = _mediaFiles.indexOf(file);
              return Stack(
                children: [
                  file.path.endsWith('.mp4')
                      ? _buildVideoPreview(file)
                      : Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(file),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeMedia(index),
                      child: const Icon(
                        MaterialIcons.remove,
                        color: AppColors.errorRed,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
            if (_mediaFiles.isEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Alinear a la izquierda
                children: [
                  GestureDetector(
                    onTap: _pickMedia,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              'Seleccionar Archivos',
                              style: TextStyle(fontSize: 14, color: AppColors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8), // Espacio entre el texto y el contador
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Alinear a la derecha
                    children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30), // Padding del lado derecho
                      child: Text(
                        '${_mediaFiles.length}/9',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.black),
                      ),
                    ),
                    ],
                  ),
                ],
              ),
            // Botón para agregar más archivos solo si hay menos de 9 archivos y al menos uno seleccionado
            if (_mediaFiles.isNotEmpty && _mediaFiles.length < 9)
              GestureDetector(
                onTap: _pickMedia,
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(
                          MaterialIcons.add, // Icono de "+"
                          size: 30,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    // Contador de archivos seleccionados debajo del ícono
                    const SizedBox(height: 8), // Espacio entre el ícono y el contador
                    Text(
                      '${_mediaFiles.length}/9',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.black),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 30), // Espacio adicional al final
      ],
    );
  }
}