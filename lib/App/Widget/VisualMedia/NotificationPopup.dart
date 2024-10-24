import 'package:flutter/material.dart';

class NotificationPopup extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const NotificationPopup({
    Key? key,
    required this.message,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss, // Cierra el popup al hacer clic
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
