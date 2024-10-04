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
      contentPadding: const EdgeInsets.only(right: 16, left: 16,top: 16, bottom: 5),
      actionsPadding: const EdgeInsets.only(bottom: 12),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centra los botones
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold,), // Texto negro
              ),
            ),
            const SizedBox(width: 20), // Espacio entre los botones
            TextButton(
              onPressed: () {
                if (onConfirmTap != null) {
                  onConfirmTap!(); // Ejecuta la función de confirmación
                }
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text(
                'Sí',
                style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold,
                        ), // Texto negro
              ),
            ),
          ],
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
    barrierDismissible: false, // No permite cerrar el diálogo al tocar fuera de él
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: title,
        content: content,
        onConfirmTap: onConfirmTap,
      );
    },
  );
}
