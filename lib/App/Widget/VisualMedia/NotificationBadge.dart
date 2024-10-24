import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final String notificationText;

  const NotificationBadge({Key? key, required this.notificationText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tamaño fijo para la altura del círculo
    double circleHeight = 16; // Altura fija

    final textPainter = TextPainter(
      text: TextSpan(
        text: notificationText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold, // Negrita
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();

    // Tamaño del círculo basado en el ancho del texto, manteniendo altura constante
    double circleWidth =
        textPainter.size.width + 9; // Añadir más padding a los lados

    return Container(
      width: circleWidth,
      height: circleHeight,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10), // Bordes redondeados
      ),
      child: Center(
        child: Text(
          notificationText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold, // Negrita
          ),
        ),
      ),
    );
  }
}
