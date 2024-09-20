import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class LoadingScreen extends StatelessWidget {
  final String animationPath;
  final double width;
  final double height;
  final Color backgroundColor;
  final double verticalOffset;  // Agregamos un nuevo parámetro para el desplazamiento vertical

  const LoadingScreen({
    Key? key,
    required this.animationPath,
    this.width = 200,
    this.height = 200,
    this.backgroundColor = AppColors.whiteapp,
    this.verticalOffset = 0.0,  // Valor por defecto para el desplazamiento vertical
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Align(
        alignment: Alignment(0.0, verticalOffset),  // Ajusta el desplazamiento vertical
        child: Lottie.asset(
          animationPath,
          width: width,
          height: height,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
