import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Label.dart'; // Asegúrate de importar el archivo de LabelAction

class ImagePickerDialog extends StatelessWidget {
  final Function(File) onImagePicked;
  final VoidCallback? onDeletePhoto; // Función para eliminar la foto
  final bool hasPhoto; // Indica si hay una foto para eliminar
  final ImagePicker _picker = ImagePicker();

  ImagePickerDialog({
    required this.onImagePicked,
    this.onDeletePhoto,
    this.hasPhoto = false,
  });

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      onImagePicked(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.whiteapp,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabelAction(
            text: 'Tomar Foto',
            icon: MaterialIcons.camera,
            onPressed: () => _pickImage(context, ImageSource.camera),
            style: TextStyle(
                color: AppColors.black, // Color rojo para el texto
                fontSize: 16, // Tamaño de texto
              ),
          ),
          LabelAction(
            text: 'Elegir Foto Existente',
            icon: MaterialIcons.image,
            onPressed: () => _pickImage(context, ImageSource.gallery),
            style: TextStyle(
                color: AppColors.black, // Color rojo para el texto
                fontSize: 16, // Tamaño de texto
              ),
          ),
          if (hasPhoto) // Muestra la opción de borrar solo si hay una foto
            LabelAction(
              text: 'Eliminar Foto',
              icon: MaterialIcons.delete,
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                onDeletePhoto!(); // Llama a la función de eliminar foto
              },
              style: TextStyle(
                color: AppColors.errorRed, // Color rojo para el texto
                fontSize: 16, // Tamaño de texto
              ),
            ),
        ],
      ),
    );
  }
}
