import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final Widget selectWidget; // Widget para el Select (por ejemplo, SelectBasic)
  final VoidCallback? onAccept; // Función que se ejecuta al aceptar

  const CustomDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.selectWidget,
    this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.whiteapp, // Fondo blanco
      title: const Text(
        'Administrar rol',
      ),
      contentPadding: const EdgeInsets.only(
        right: 16,
        left: 16,
        top: 16,
        bottom: 5,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: const TextStyle(color: AppColors.black), // Texto negro
            ),
            const SizedBox(height: 16),
            selectWidget, // El widget para el SelectBasic se pasa aquí
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.only(bottom: 12), // Padding para los botones
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centra los botones
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold, // Texto negro y en negrita
                ),
              ),
            ),
            const SizedBox(width: 20), // Espacio entre los botones
            TextButton(
              onPressed: () {
                if (onAccept != null) {
                  onAccept!(); // Ejecuta la función pasada al aceptar
                }
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold, // Texto negro y en negrita
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
