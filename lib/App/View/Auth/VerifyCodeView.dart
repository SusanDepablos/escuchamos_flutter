import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/CustomLabel.dart'; 
import 'package:escuchamos_flutter/App/Widget/Logo.dart';
import 'package:escuchamos_flutter/App/Widget/CustomDigitInput.dart'; // Importa el widget

class VerifyCodeView extends StatelessWidget {
  final String email;
  final TextEditingController _codeController = TextEditingController(); // Controlador para el código

  VerifyCodeView({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, // Establece el fondo del AppBar a blanco
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogoBanner(size: MediaQuery.of(context).size.width), // Ocupa todo el ancho
            SizedBox(height: 8.0), // Puedes reducir este espacio o eliminarlo
            // Agregar el Label con el texto de verificación
            Label(
              name: "Verifica tu correo electrónico",
              route: "", // Puedes especificar la ruta si se requiere navegación
              color: Colors.black, // Color del texto
            ),
            SizedBox(height: 8.0), // Espacio entre el Label y el siguiente texto
            Text(
              'Escribe el código de 6 dígitos que enviamos a:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              email,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 26.0), // Espacio antes del campo de código
            CustomDigitInput(
              input: _codeController, // Pasa el controlador al widget de entrada de dígitos
              border: Colors.blue, // Color del borde del input
            ),
            // Aquí puedes agregar más widgets si es necesario
          ],
        ),
      ),
    );
  }
}
