import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco para una apariencia limpia
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animación Lottie
            Lottie.asset(
              'assets/no_connection.json', // Asegúrate de añadir la animación Lottie en assets
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // Texto indicando que no hay conexión
            Text(
              'No hay conexión a Internet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 10),
            // Texto adicional
            Text(
              'Por favor, revisa tu conexión.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
