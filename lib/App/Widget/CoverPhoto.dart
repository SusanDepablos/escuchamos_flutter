import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Icons.dart';

class CoverPhoto extends StatelessWidget {
  final VoidCallback? onPressed;
  final double height;
  final double iconSize;
  final ImageProvider? imageProvider;
  final bool isEditing; // Parámetro para indicar si se está editando

  CoverPhoto({
    this.onPressed,
    this.height = 120,
    this.iconSize = 24.0,
    this.imageProvider,
    this.isEditing = false, // Inicializar el parámetro
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Widget coverPhoto = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.inputLigth,
        borderRadius: BorderRadius.circular(12.0),
        image: imageProvider != null
            ? DecorationImage(
                image: imageProvider!,
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Stack(
        children: [
          if (imageProvider == null && !isEditing)
            Center(
              child: Icon(
                MaterialIcons.image,
                color: AppColors.inputDark,
                size: iconSize,
              ),
            ),
          if (isEditing)
            Center(
              child: Icon(
                MaterialIcons.addphoto,
                color: Colors.white,
                size: iconSize,
              ),
            ),
        ],
      ),
    );

    // Aplica la opacidad solo si isEditing es true y hay una imagen
    if (isEditing && imageProvider != null) {
      coverPhoto = Opacity(
        opacity: 0.6,
        child: coverPhoto,
      );
    }

    if (onPressed != null) {
      return IconButton(
        icon: coverPhoto,
        onPressed: onPressed,
      );
    } else {
      return GestureDetector(
        child: coverPhoto,
        onTap: () {},
      );
    }
  }
}
