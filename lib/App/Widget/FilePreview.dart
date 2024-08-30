import 'package:flutter/material.dart';
import 'dart:io';

class ImagePreview extends StatelessWidget {
  final File? image;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  ImagePreview({
    required this.image,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 300.0,
            width: double.infinity,
            child: image != null
                ? Image.file(
                    image!,
                    fit: BoxFit.cover,
                  )
                : Center(child: Text('No Image Selected')),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: onCancel,
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: onConfirm,
                child: Text('Confirmar'),
              ),
            ],
          ),
        ],
      ),
    );
    
  }
}
