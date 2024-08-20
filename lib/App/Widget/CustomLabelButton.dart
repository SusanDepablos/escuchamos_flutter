import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class LabelButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? style;
  final bool isLoading;

  LabelButton({
    required this.text,
    required this.onPressed,
    this.style,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Indicador de carga visible cuando isLoading es true
            Visibility(
              visible: isLoading,
              child: SizedBox(
                width: 16, // Ancho del indicador de carga
                height: 16, // Alto del indicador de carga
                child: CircularProgressIndicator(
                  strokeWidth: 2, // Grosor del indicador
                ),
              ),
            ),
            // Texto visible cuando isLoading es false
            Visibility(
              visible: !isLoading,
              child: Text(
                text,
                style: style ?? TextStyle(
                  color: AppColors.primaryBlue, // Color de texto azul por defecto
                  fontSize: 16, // Tamaño de fuente por defecto
                  decoration: TextDecoration.underline, // Subrayado como un enlace
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
