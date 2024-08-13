import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/CustomLabel.dart'; // Asegúrate de ajustar la ruta al Login

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Register'),
            SizedBox(height: 20), // Espacio entre el texto y el Label
            Label(
              name: '¿Ya tienes una cuenta? Inicia sesión',
              route: 'login', // Ruta al login
              color: Colors.black, // Color del texto negro
            ),
          ],
        ),
      ),
    );
  }
}
