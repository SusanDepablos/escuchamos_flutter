import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/CustomLabel.dart'; 
import 'package:escuchamos_flutter/App/Widget/CountDownTimer.dart'; 
import 'package:escuchamos_flutter/App/Widget/Logo.dart';
import 'package:escuchamos_flutter/App/Widget/CustomDigitInput.dart'; // Importa el widget

class VerifyCodeView extends StatelessWidget {
  final String email;
  final TextEditingController _codeController = TextEditingController();

  VerifyCodeView({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, 
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogoBanner(size: MediaQuery.of(context).size.width), 
            SizedBox(height: 8.0), 
            Label(
              name: "Verifica tu correo electrónico",
              route: "", 
              color: Colors.black, 
            ),
            SizedBox(height: 8.0), 
            Text(
              'Escribe el código de 6 dígitos que enviamos a:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              email,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 26.0), 
            CustomDigitInput(
              input: _codeController, 
              border: Colors.blue, 
            ),
            SizedBox(height: 16.0), 
            Text(
              'Puedes solicitar un nuevo código en:',
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            CountdownTimer(), // Aquí se muestra el temporizador
          ],
        ),
      ),
    );
  }
}