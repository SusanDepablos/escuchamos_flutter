import 'package:flutter/material.dart';

/// Un widget de ventana emergente que muestra un cuadro de diálogo con un título y un mensaje.
///
/// Este widget se utiliza para mostrar una ventana emergente personalizada
/// en la interfaz de usuario. Acepta un título y un mensaje a través de su
/// constructor, que se muestran en el cuadro de diálogo.
class PopupWindow extends StatelessWidget {
  final String title; // Título del cuadro de diálogo
  final String message; // Mensaje del cuadro de diálogo

  /// Constructor del widget PopupWindow.
  ///
  /// [title] El título que se mostrará en el cuadro de diálogo.
  /// [message] El mensaje que se mostrará en el cuerpo del cuadro de diálogo.
  PopupWindow({
    this.title = '', // Valor por defecto
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18, // Tamaño de la fuente del título
          fontWeight: FontWeight.bold, // Opcional: para hacer el título negrita
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          fontSize: 15, // Tamaño de la fuente del mensaje
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'ACEPTAR',
            style: TextStyle(
              fontSize: 14, // Tamaño de la fuente del texto del botón
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
