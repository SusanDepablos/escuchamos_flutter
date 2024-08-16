import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double size;

  Logo({this.size = 150.0});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png', // Ruta a tu imagen de logo
      width: size,
      height: size,
    );
  }
}

class LogoBanner extends StatelessWidget {
  final double size;

  LogoBanner({this.size = 90.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/banner.png', // Ruta a tu imagen de banner
        width: MediaQuery.of(context).size.width * 0.8, // Ajusta el ancho al 80% del tamaño de la pantalla
        fit: BoxFit.cover,
      ),
    );
  }
}





