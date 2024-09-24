import 'dart:io';
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
    final XFile? mediaFile = await showModalBottomSheet<XFile?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.whiteapp, // Cambia este color por el que prefieras
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)), // Opcional: redondear la parte superior
          ),
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Imagen'),
                onTap: () async {
                  Navigator.pop(context); // Cerrar el modal
                  final List<XFile>? selectedFiles = await _picker.pickMultiImage();
                  if (selectedFiles != null) {
                    _addMediaFiles(selectedFiles);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Video'),
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
        // Comprobar que no se exceda el límite
        if (_mediaFiles.length < 9) {
          _mediaFiles.add(File(mediaFile.path));
        }
      }
      widget.onMediaChanged(_mediaFiles); // Notificamos al padre
    });
  }

  // Método para eliminar un archivo seleccionado
  void _removeMedia(int index) {
    setState(() {
      _mediaFiles.removeAt(index);
      widget.onMediaChanged(_mediaFiles); // Notificamos al padre
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
      child: Icon(
        Icons.videocam,
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
                      child: Icon(
                        Icons.remove_circle,
                        color: AppColors.errorRed,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),

            // Label de seleccionar archivo que ocupe todo el ancho con padding alrededor del texto
            if (_mediaFiles.isEmpty)
              GestureDetector(
                onTap: _pickMedia, // Selección de archivo
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Foto/Video',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

            // Botón para agregar más archivos solo si hay menos de 9 archivos y al menos uno seleccionado
            if (_mediaFiles.isNotEmpty && _mediaFiles.length < 9)
              GestureDetector(
                onTap: _pickMedia,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add, // Icono de "+"
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),

        // Contador de archivos seleccionados
        SizedBox(height: 15), // Espacio entre el Wrap y el contador
        Text(
          '${_mediaFiles.length}/9',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15), 
      ],
    );
  }
}
