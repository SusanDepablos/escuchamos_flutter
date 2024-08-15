import 'dart:convert';
import 'package:flutter/material.dart';

class ApiUrl{
  // ---------------------------URL base de la API ---------------------------//

  //url para pruebas locales:
  static const String baseUrl = 'https://escuchamos-mcu6.onrender.com/api/';

  //url para pruebas en el servidor:
  // static const String baseUrl = 'https://escuchamos.onrender.com';

  // -------------------------------------------------------------------------//
}

  // ---------------------------colores de la app ---------------------------//
class AppColors {

  static const Color black = Color.fromRGBO(0, 0, 0, 1); // Color negro
  static const Color primaryBlue = Color.fromRGBO(22, 45, 222, 1); // Azul primario de la app
  static const Color lightBlue = Color.fromRGBO(226, 227, 248, 1); // Azul claro para notificaciones
  static const Color deepPurple = Color.fromRGBO(74, 1, 125, 1); // Morado profundo
  static const Color errorRed = Color.fromRGBO(234, 22, 19, 1); // Rojo para errores
  static const Color lightErrorRed = Color.fromRGBO(255, 225, 224, 1); // Rojo claro para notificaciones de error
}
  // -------------------------------------------------------------------------//