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
