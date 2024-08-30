import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Icons.dart';

class ImagePickerDialog extends StatelessWidget {
  final Function(File) onImagePicked;
  final ImagePicker _picker = ImagePicker();

  ImagePickerDialog({required this.onImagePicked});

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
          ListTile(
            leading: Icon(MaterialIcons.camera),
            title: Text('Tomar Foto'),
            onTap: () => _pickImage(context, ImageSource.camera),
          ),
          ListTile(
            leading: Icon(MaterialIcons.image),
            title: Text('Elegir Foto Existente'),
            onTap: () => _pickImage(context, ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}
