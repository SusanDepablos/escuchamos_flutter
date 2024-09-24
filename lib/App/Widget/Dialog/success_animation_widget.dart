import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessAnimationWidget extends StatelessWidget {
  const SuccessAnimationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      // Envolver en un Center para centrar
      child: Transform.scale(
        scale: 1.9, // Escalar la animación para eliminar espacio blanco
        child: Lottie.asset(
          'assets/succes.json',
          width: 180,
          height: 180,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
