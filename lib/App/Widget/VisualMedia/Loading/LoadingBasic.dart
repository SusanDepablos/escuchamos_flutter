import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final Color color;
  final double? size; // Tamaño opcional

  CustomLoadingIndicator({this.color = Colors.blue, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: size != null
          ? SizedBox(
              width: size, // Ancho del indicador
              height: size, // Alto del indicador
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(color),
                strokeWidth: 3.0, // Grosor del círculo (opcional)
              ),
            )
          : CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(color),
              strokeWidth: 5.0, // Grosor del círculo (opcional)
            ),
    );
  }
}
