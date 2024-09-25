import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class FloatingAddButton extends StatelessWidget {
  final VoidCallback onTap;
  final double borderRadius; // Control del radio de las esquinas

  const FloatingAddButton(
      {Key? key, required this.onTap, this.borderRadius = 30.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30.0, // Espacio desde la parte inferior
      right: 16.0, // Espacio desde la derecha
      child: MouseRegion(
        cursor: SystemMouseCursors.click, // Cambia el cursor al pasar el ratón
        child: Tooltip(
          message: "Comentar", // Mensaje del tooltip
          child: Container(
            width: 53.0, // Ancho del contenedor
            height: 53.0, // Alto del contenedor
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  borderRadius), // Control del radio de las esquinas
              color: AppColors.primaryBlue, // Color de fondo
              boxShadow: [
                BoxShadow(
                  color: AppColors.black
                      .withOpacity(0.3), // Color de la sombra más opaco
                  blurRadius: 10.0, // Aumentar el difuminado de la sombra
                  offset:
                      Offset(0, 6), // Aumentar el desplazamiento de la sombra
                ),
              ],
            ),
            child: GestureDetector(
              onTap: onTap,
              child: CustomPaint(
                size: const Size(56.0, 56.0), // Tamaño del símbolo "+"
                painter: PlusPainter(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white // Color del símbolo "+"
      ..style = PaintingStyle.fill;

    // Dimensiones para el símbolo "+"
    double lineWidth = 4; // Ancho de las líneas
    double lineLength = 25.0; // Longitud de las líneas del símbolo "+"
    double cornerRadius = 3.0; // Radio para esquinas redondeadas
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    // Dibuja la línea vertical con esquinas redondeadas
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - lineWidth / 2, centerY - lineLength / 2,
            lineWidth, lineLength),
        Radius.circular(cornerRadius),
      ),
      paint,
    );

    // Dibuja la línea horizontal con esquinas redondeadas
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - lineLength / 2, centerY - lineWidth / 2,
            lineLength, lineWidth),
        Radius.circular(cornerRadius),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
