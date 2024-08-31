import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class CoverPhoto extends StatelessWidget {
  final VoidCallback? onPressed;
  final double height; // Altura de la foto
  final double iconSize; // Tamaño del ícono
  final ImageProvider? imageProvider; // Parámetro para la imagen de fondo

  CoverPhoto({
    this.onPressed,
    this.height = 120, // Altura por defecto
    this.iconSize = 24.0, // Tamaño del ícono por defecto
    this.imageProvider, // Inicializar el parámetro
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; // Obtiene el ancho de la pantalla

    Widget coverPhoto = Container(
      width: width, // Usa el ancho de la pantalla
      height: height, // Usa la altura proporcionada
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
      child: imageProvider == null
          ? Center(
              child: Icon(
                Icons.image,
                color: AppColors.inputDark,
                size: iconSize, // Tamaño del ícono
              ),
            )
          : null, // No muestra el ícono si imageProvider no es null
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
          // No hace nada si onPressed es null
        },
      );
    }
  }
}
