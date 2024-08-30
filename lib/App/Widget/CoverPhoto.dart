import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class CoverPhoto extends StatelessWidget {
  final VoidCallback? onPressed;
  final double height; // Ahora solo recibe la altura
  final double iconSize;

  CoverPhoto({
    this.onPressed,
    this.height = 120, // Altura requerida
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; // Obtén el ancho de la pantalla

    Widget coverPhoto = Container(
      width: width, // Usa el ancho de la pantalla
      height: height, // Usa la altura proporcionada
      decoration: BoxDecoration(
        color: AppColors.inputLigth,
        borderRadius: BorderRadius.circular(12.0),
        image: DecorationImage(
          image: AssetImage('assets/default_cover_photo.png'), // Imagen predeterminada
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image,
          color: AppColors.inputDark,
          size: iconSize,
        ),
      ),
    );

    if (onPressed != null) {
      return IconButton(
        icon: coverPhoto,
        onPressed: onPressed,
      );
    } else {
      return GestureDetector(
        child: coverPhoto,
        onTap: () {
          // No hacer nada si onPressed es null
        },
      );
    }
  }
}
