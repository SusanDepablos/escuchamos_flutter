import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

/// Un widget de ventana emergente que muestra un cuadro de diálogo con un título y un mensaje.
///
/// Este widget se utiliza para mostrar una ventana emergente personalizada
/// en la interfaz de usuario. Acepta un título y un mensaje a través de su
/// constructor, que se muestran en el cuadro de diálogo.
class PopupWindow extends StatelessWidget {
  final String title; // Título del cuadro de diálogo
  final String message; // Mensaje del cuadro de diálogo
  final Color titleColor; // Color del título
  final Color messageColor; // Color del mensaje
  final Color buttonColor; // Color del botón
  final Color backgroundColor; // Color de fondo del diálogo

  /// Constructor del widget PopupWindow.
  ///
  /// [title] El título que se mostrará en el cuadro de diálogo.
  /// [message] El mensaje que se mostrará en el cuerpo del cuadro de diálogo.
  /// [titleColor] El color del texto del título.
  /// [messageColor] El color del texto del mensaje.
  /// [buttonColor] El color del texto del botón.
  /// [backgroundColor] El color de fondo del cuadro de diálogo.
  PopupWindow({
    this.title = '', // Valor por defecto
    required this.message,
    this.titleColor = AppColors.black,
    this.messageColor = AppColors.inputDark,
    this.buttonColor = AppColors.primaryBlue,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20, // Tamaño de la fuente del título
          fontWeight: FontWeight.bold, // Opcional: para hacer el título negrita
          color: titleColor, // Aplicar color al título
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0), // Espacio entre el título y el mensaje
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16, // Tamaño de la fuente del mensaje
            color: messageColor, // Aplicar color al mensaje
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryBlue, // Color del texto blanco
            backgroundColor: backgroundColor.withOpacity(0.1), // Fondo sutil del botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Esquinas redondeadas
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Relleno del botón
          ),
          child: Text(
            'Aceptar',
            style: TextStyle(
              fontSize: 16, // Tamaño de la fuente del texto del botón
              fontWeight: FontWeight.bold, // Negrita para mayor énfasis
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      backgroundColor: backgroundColor, // Aplicar color de fondo al diálogo
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Esquinas redondeadas del cuadro de diálogo
      ),
      contentPadding: EdgeInsets.all(20), // Espacio interno del contenido
    );
  }
}
