import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/View/Auth/Login.dart';
import 'package:escuchamos_flutter/App/View/Auth/RecoverAccount.dart';
import 'package:escuchamos_flutter/App/View/Auth/Register.dart';
import 'package:escuchamos_flutter/App/View/Auth/VerifyCodeView.dart';
import 'package:escuchamos_flutter/App/View/Home.dart';

class AppRoutes {
  static final routes = {
    'login': (context) => Login(), // Pantalla de inicio de sesión
    'home': (context) => Home(), // No pasa argumentos aquí
    'recover-account': (context) => RecoverAccount(), // Pantalla para recuperar la cuenta
    'register': (context) => Register(), // Pantalla para registrar una nueva cuenta
    'verify-code': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      return VerifyCodeView(email: args);
    }, // Pantalla para verificar el código
  };
}
