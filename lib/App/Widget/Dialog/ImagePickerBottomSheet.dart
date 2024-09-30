import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ImagePickerBottomSheet extends StatelessWidget {
  final Function(File) onImagePicked;
  final VoidCallback? onDeletePhoto;
  final bool hasPhoto;
  final ImagePicker _picker = ImagePicker();

  ImagePickerBottomSheet({
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
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.whiteapp,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)), // Bordes redondeados
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(MaterialIcons.camera, color: AppColors.black),
            title: const Text('Tomar Foto', style: TextStyle(color: AppColors.black)), // Color del texto igual al ícono
            onTap: () {
              _pickImage(context, ImageSource.camera);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(MaterialIcons.image, color: AppColors.black),
            title: const Text('Elegir Foto Existente', style: TextStyle(color: AppColors.black)), // Color del texto igual al ícono
            onTap: () {
              _pickImage(context, ImageSource.gallery);
              Navigator.of(context).pop();
            },
          ),
          if (hasPhoto)
            ListTile(
              leading: const Icon(MaterialIcons.delete, color: AppColors.errorRed),
              title: const Text('Eliminar Foto', style: TextStyle(color: AppColors.errorRed)), // Color del texto igual al ícono
              onTap: () {
                if (onDeletePhoto != null) {
                  onDeletePhoto!();
                }
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}
