import 'dart:io';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Label.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class ImagePreview extends StatefulWidget {
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
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  String buttonText = 'Confirmar';
  bool isUploading = false;

  void handleConfirm() async {
    setState(() {
      buttonText = 'Subiendo...';
      isUploading = true;
    });

    // Simulando un retraso para demostrar el cambio de estado
    await Future.delayed(Duration(seconds: 2));

    // Ejecuta la lógica de confirmación pasada
    widget.onConfirm();

    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = widget.isCoverPhoto ? 140.0 : 300.0;
    double width = widget.isCoverPhoto ? MediaQuery.of(context).size.width : 300.0;
    double margin = widget.isCoverPhoto ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        elevation: 0,
        leading: IconButton(
          icon: Icon(MaterialIcons.close, color: AppColors.whiteapp),
          onPressed: widget.onCancel,
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: margin),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: widget.isCoverPhoto
                    ? BorderRadius.circular(8.0)
                    : BorderRadius.circular(8.0),
                child: PhotoView(
                  imageProvider: widget.image != null ? FileImage(widget.image!) : null,
                  minScale: PhotoViewComputedScale.covered,
                  maxScale: PhotoViewComputedScale.covered * 4,
                  backgroundDecoration: BoxDecoration(
                    color: AppColors.dark,
                  ),
                  enableRotation: false,
                  enablePanAlways: true,
                  customSize: Size(width, height),
                  initialScale: PhotoViewComputedScale.covered,
                ),
              ),
              if (widget.isCoverPhoto)
                Positioned(
                  child: IgnorePointer(
                    child: Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.whiteapp, width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              if (!widget.isCoverPhoto)
                Positioned(
                  child: IgnorePointer(
                    child: Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.whiteapp, width: 2),
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
              text: buttonText,
              onPressed: isUploading ? null : handleConfirm, // Desactivar botón cuando se está subiendo
              style: const TextStyle(color: AppColors.whiteapp),
            ),
          ],
        ),
      ),
    );
  }
}
