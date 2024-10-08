import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Label.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class ImagePreview extends StatelessWidget {
  final File? image;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool isCoverPhoto;

  ImagePreview({
    required this.image,
    required this.onConfirm,
    required this.onCancel,
    required this.isCoverPhoto,
  });

  @override
  Widget build(BuildContext context) {
    double height = isCoverPhoto ? 140.0 : 300.0;
    double width = isCoverPhoto ? MediaQuery.of(context).size.width : 300.0;
    double margin = isCoverPhoto ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.whiteapp),
          onPressed: onCancel,
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: margin),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Imagen completa de fondo
              ClipRRect(
                borderRadius: isCoverPhoto
                    ? BorderRadius.circular(8.0) // Borde rectangular para portada
                    : BorderRadius.circular(8.0), // Sin borde redondeado para perfil
                child: PhotoView(
                  imageProvider: image != null ? FileImage(image!) : null,
                  minScale: PhotoViewComputedScale.covered,
                  maxScale: PhotoViewComputedScale.covered * 4,
                  backgroundDecoration: BoxDecoration(
                    color: AppColors.dark,
                  ),
                  enableRotation: false,
                  enablePanAlways: true,
                  customSize: Size(width, height), // Tamaño personalizado
                  initialScale: PhotoViewComputedScale.covered, // Ajusta la imagen para cubrir el área visible
                ),
              ),
              // Borde externo general
              if (isCoverPhoto)
                Positioned(
                  child: IgnorePointer(
                    child: Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.whiteapp, width: 2), // Borde externo blanco
                        borderRadius: BorderRadius.circular(8.0), // Borde rectangular
                      ),
                    ),
                  ),
                ),
              if (!isCoverPhoto)
                Positioned(
                  child: IgnorePointer(
                    child: Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Borde circular para perfil
                        border: Border.all(color: AppColors.whiteapp, width: 2), // Resalta el recorte circular
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.dark,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LabelAction(
              text: 'Confirmar',
              onPressed: onConfirm,
              style: TextStyle(color: AppColors.whiteapp),
            ),
                ],
        ),
      ),
    );
  }
}
