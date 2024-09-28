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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Tomar Foto'),
            onTap: () {
              _pickImage(context, ImageSource.camera);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Elegir Foto Existente'),
            onTap: () {
              _pickImage(context, ImageSource.gallery);
              Navigator.of(context).pop();
            },
          ),
          if (hasPhoto)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Eliminar Foto'),
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
