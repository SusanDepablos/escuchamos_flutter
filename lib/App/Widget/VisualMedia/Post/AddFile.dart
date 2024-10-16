import 'dart:io';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

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
    await showModalBottomSheet<XFile?>( // Mostrar un modal para seleccionar el tipo de medio
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
                leading: const Icon( CupertinoIcons.photo_camera_solid, size: AppFond.iconShare,color: AppColors.black),
                title: const Text('Tomar Foto', style: TextStyle(fontSize: AppFond.subtitle, color: AppColors.black),textScaleFactor: 1.0), // Opción para tomar foto
                onTap: () {
                  _pickImage(context, ImageSource.camera); // Llama al método para tomar una foto
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.photo_fill, size: AppFond.iconShare, color: AppColors.black),
                title: const Text('Imagen', style: TextStyle(fontSize: AppFond.subtitle, color: AppColors.black,), textScaleFactor: 1.0), // Opción para seleccionar imágenes de la galería
                onTap: () async {
                  Navigator.pop(context); // Cerrar el modal
                  final List<XFile>? selectedFiles = await _picker.pickMultiImage();
                  if (selectedFiles != null) {
                    _addMediaFiles(selectedFiles); // Agregar archivos seleccionados
                  }
                },
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.video_camera_solid, size: AppFond.iconShare, color: AppColors.black),
                title: const Text('Video', style: TextStyle(fontSize: AppFond.subtitle, color: AppColors.black), textScaleFactor: 1.0), // Opción para seleccionar videos de la galería
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
  
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source); // Selecciona la imagen
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      _addMediaFiles([pickedFile]); // Agrega la imagen a los archivos multimedia
    }
  }

  // Método para agregar archivos a la lista
  void _addMediaFiles(List<XFile> selectedFiles) async {
    for (var mediaFile in selectedFiles) {
      File file = File(mediaFile.path);
      
      // Comprimir solo si es una imagen (ignorar videos)
      if (file.path.endsWith('.jpg') || file.path.endsWith('.jpeg') || file.path.endsWith('.png')) {
        file = await _compressImage(file); // Comprimir la imagen
      }

      if (_mediaFiles.length < 9) {
        setState(() {
          _mediaFiles.add(file);
        });
      }
    }
    widget.onMediaChanged(_mediaFiles); // Notificar cambios en los archivos
  }

  Future<File> _compressImage(File file) async {
    final originalImage = img.decodeImage(await file.readAsBytes());

    // Redimensionar la imagen
    final resizedImage = img.copyResize(originalImage!, width: 800); // Ajusta según necesites

    // Codificar la imagen redimensionada a bytes
    final compressedBytes = img.encodeJpg(resizedImage, quality: 80); // Ajusta la calidad

    // Crear un archivo temporal para la imagen comprimida
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg');
    
    await tempFile.writeAsBytes(compressedBytes);
    return tempFile;
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
                              style: TextStyle(fontSize: AppFond.subtitle, color: AppColors.black),
                              textScaleFactor: 1.0
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
                        style: const TextStyle(fontSize: AppFond.subtitle, fontWeight: FontWeight.bold, color: AppColors.black),
                        textScaleFactor: 1.0       
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
