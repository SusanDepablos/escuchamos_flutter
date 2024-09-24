import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

/// Un widget de ventana emergente que muestra un cuadro de diálogo con un título y un mensaje.
///
/// Este widget se utiliza para mostrar una ventana emergente personalizada
/// en la interfaz de usuario. Acepta un título y un mensaje a través de su
/// constructor, que se muestran en el cuadro de diálogo.
class PopupWindow extends StatelessWidget {
  final String title;
  final String message;
  final Color titleColor;
  final Color messageColor;
  final Color buttonColor;
  final Color backgroundColor;
  final Widget? child; // Añadir el parámetro child opcional

  PopupWindow({
    this.title = '',
    required this.message,
    this.titleColor = AppColors.black,
    this.messageColor = AppColors.inputDark,
    this.buttonColor = AppColors.primaryBlue,
    this.backgroundColor = Colors.white,
    this.child, // Inicializa el child
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: titleColor,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: messageColor,
            ),
          ),
          if (child != null) ...[
            const SizedBox(height: 20),
            child!, // Mostrar el widget child si no es nulo
          ],
        ],
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryBlue,
            backgroundColor: backgroundColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          child: const Text(
            'Aceptar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      contentPadding: const EdgeInsets.all(20),
    );
  }
}

/////////////////////////////////////////////////

class AutoClosePopup extends StatelessWidget {
  final String? title; // Permitir que el título sea nulo
  final String message;
  final Color titleColor;
  final Color messageColor;
  final Color backgroundColor;
  final Widget? child; // Añadir el parámetro child opcional

  AutoClosePopup({
    this.title,
    required this.message,
    this.titleColor = Colors.black,
    this.messageColor = Colors.black54,
    this.backgroundColor = Colors.white,
    this.child, // Inicializa el child
  });

  @override
  Widget build(BuildContext context) {
    // Programar el cierre del diálogo después de 4 segundos
    Future.delayed(Duration(milliseconds: 1850), () {
      Navigator.of(context).pop(); // Cerrar el diálogo automáticamente
    });

    return AlertDialog(
      title: (title != null &&
              title!
                  .isNotEmpty) // Verificar si el título no es nulo y no está vacío
          ? Text(
              title!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            )
          : null, // Si es nulo o vacío, no se renderiza el título
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (child != null) ...[
            const SizedBox(height: 20),
            child!, // Mostrar el widget child si no es nulo
          ],
          SizedBox(height: 5.0),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold, // Poner el mensaje en negrita
              color: messageColor,
            ),
            textAlign: TextAlign.center, // Centrar el texto del mensaje
          ),
          SizedBox(height: 37.0),
        ],
      ),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      contentPadding: const EdgeInsets.all(20),
    );
  }
}
