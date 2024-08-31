import 'package:flutter/material.dart';


/// Un widget que muestra un logotipo centrado en la pantalla.
class Logo extends StatelessWidget {
  final double size;

  Logo({this.size = 150.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/logo.png', // Ruta a tu imagen de banner
        width: MediaQuery.of(context).size.width * 0.6, // Ajusta el ancho al 80% del tamaño de la pantalla
        fit: BoxFit.cover,
      ),
    );
  }
}

/// Un widget que muestra un icono centrado en la pantalla.
class LogoIcon extends StatelessWidget {
  final double size;

  LogoIcon({this.size = 150.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/LogoIcon.png', // Ruta a tu imagen de banner
        width: MediaQuery.of(context).size.width * 0.3, // Ajusta el ancho al 80% del tamaño de la pantalla
        fit: BoxFit.cover,
      ),
    );
  }
}


/// Un widget que muestra una imagen de banner centrada en la pantalla.
class LogoBanner extends StatelessWidget {
  final double size;

  LogoBanner({this.size = 70.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/banner.png', // Ruta a tu imagen de banner
        width: MediaQuery.of(context).size.width * 0.6, // Ajusta el ancho al 80% del tamaño de la pantalla
        fit: BoxFit.cover,
      ),
    );
  }
}





