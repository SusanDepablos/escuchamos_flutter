import 'package:escuchamos_flutter/App/Widget/Dialog/ShowConfirmationDialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Label.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/ImagePickerDialog.dart';

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

  void _showDeleteConfirmation(BuildContext context) {
    showConfirmationDialog(
      context,
      title: 'Eliminar Foto',
      content: '¿Estás seguro de que quieres eliminar esta foto? Esta acción no se puede deshacer.',
      onConfirmTap: () {
        if (onDeletePhoto != null) {
          onDeletePhoto!(); // Llama a la función de eliminación
        }
      },
    );
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
            icon: CupertinoIcons.photo_camera_solid,
            onPressed: () => _pickImage(context, ImageSource.camera),
            style: const TextStyle(
                color: AppColors.black, // Color rojo para el texto
                fontSize: AppFond.label, // Tamaño de texto
              ),
          ),
          LabelAction(
            text: 'Elegir Foto Existente',
            icon: CupertinoIcons.photo_fill,
            onPressed: () => _pickImage(context, ImageSource.gallery),
            style: const TextStyle(
                color: AppColors.black, // Color rojo para el texto
                fontSize: AppFond.label, // Tamaño de texto
              ),
          ),
          if (hasPhoto) // Muestra la opción de borrar solo si hay una foto
            LabelAction(
              text: 'Eliminar Foto',
              icon: CupertinoIcons.delete_solid,
              onPressed: () {
                Navigator.of(context).pop();
                _showDeleteConfirmation(context);
              },
              style: const TextStyle(
                color: AppColors.errorRed, // Color rojo para el texto
                fontSize: AppFond.label, // Tamaño de texto
              ),
            ),
        ],
      ),
    );
  }
}
