import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback? onConfirmTap;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirmTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.whiteapp, // Fondo blanco
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar el diálogo
          },
          child: const Text(
            'Cancelar',
            style: TextStyle(color: AppColors.black), // Texto negro
          ),
        ),
        TextButton(
          onPressed: () {
            if (onConfirmTap != null) {
              onConfirmTap!(); // Ejecuta la función de confirmación
            }
            Navigator.of(context).pop(); // Cerrar el diálogo
          },
          child: const Text(
            'Sí',
            style: TextStyle(color: AppColors.black), // Texto negro
          ),
        ),
      ],
    );
  }
}

// Función para mostrar el diálogo
void showConfirmationDialog(BuildContext context, {
  required String title,
  required String content,
  required VoidCallback onConfirmTap,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: title,
        content: content,
        onConfirmTap: onConfirmTap,
      );
    },
  );
}
