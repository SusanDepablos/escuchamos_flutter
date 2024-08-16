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

  static const Color black = Color.fromRGBO(0, 0, 32, 1); // Color negro
  static const Color whiteapp = Color.fromRGBO(245, 245, 245, 1); // Color blanco
  static const Color primaryBlue = Color.fromRGBO(29, 36, 202, 1); // Azul primario de la app
  static const Color lightBlue = Color.fromRGBO(226, 227, 248, 1); // Azul claro para notificaciones
  static const Color deepPurple = Color.fromRGBO(74, 1, 125, 1); // Morado profundo
  static const Color errorRed = Color.fromRGBO(216, 0, 50, 1); // Rojo para errores
  static const Color lightErrorRed = Color.fromRGBO(255, 225, 224, 1); // Rojo claro para notificaciones de error
}
  // -------------------------------------------------------------------------//