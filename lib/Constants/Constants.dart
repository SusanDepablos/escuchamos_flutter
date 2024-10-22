import 'package:flutter/material.dart';

class ApiUrl{
  // ---------------------------URL base de la API ---------------------------//

  //url para pruebas en el servidor:
  // static const String baseUrl = 'https://asociacioncivilescuchamos.onrender.com/ac/api/';
  static const String baseUrl = 'http://127.0.0.1:8000/ac/api/';

  // -------------------------------------------------------------------------//

  //paginas:
  static const String WebSite = 'https://asociacioncivilescuchamos.onrender.com';
  static const String Facebook= 'https://www.facebook.com/ProyectosEscuChamos';
  static const String Correo = 'mailto:escuchamos2024@gmail.com';

  // -------------------------------------------------------------------------//
}

  // ---------------------------colores de la app ---------------------------//
class AppColors {

  static const Color dark = Color.fromRGBO(0, 0, 0, 1); // Color negro
  static const Color black = Color.fromRGBO(0, 0, 32, 1); // Color negro
  static const Color white = Color.fromRGBO(255, 255, 255, 1); // Color blanco
  static const Color whiteapp = Color.fromRGBO(245, 245, 245, 1); // Color blanco app
  static const Color primaryBlue = Color.fromRGBO(29, 36, 202, 1); // Azul primario de la app
  static const Color lightBlue = Color.fromRGBO(226, 227, 248, 1); // Azul claro para notificaciones
  static const Color deepPurple = Color.fromRGBO(74, 1, 125, 1); // Morado profundo
  static const Color errorRed = Color.fromRGBO(216, 0, 50, 1); // Rojo para errores
  static const Color lightErrorRed = Color.fromRGBO(255, 225, 224, 1); // Rojo claro para notificaciones de error
  static const Color inputBasic = Color.fromRGBO(82, 82, 82, 0.773);
  static const Color inputDark = Color.fromRGBO(79, 79, 79, 1);
  static const Color inputLigth = Color.fromRGBO(192, 192, 192, 0.827);
  static const Color greyLigth = Color.fromARGB(200, 235, 235, 235);
  static const Color grey = Colors.grey;
}
  // -------------------------------------------------------------------------//

class AppFond {
  static const double title = 18.0; // Tamaño de letra para el título
  static const double label = 16.0;
  static const double subtitle = 14.0; // Tamaño de letra para el subtítulo
  static const double text = 12.00;
  static const double username = 15.0;
  static const double name = 13.0;
  static const double date = 12.0;
  static const double body = 14.0;
  static const double count = 15.0;
  static const double countComment = 14.0;
  static const double response = 13.0;

// ----------------------------Iconos---------------------------------------------//
  static const double iconVerified = 14.0;
  static const double iconMore = 20.0;
  static const double iconHeart = 20.0;
  static const double iconHeartComment = 18.0;
  static const double iconChat = 20.0;
  static const double iconShare = 20.0;
  static const double avatarSize = 40.0;
  static const double avatarSizeSmall = 25.0;
  static const double avatarSizeShare = 30.0;
  static const double iconSize = 25.0;
  static const double iconSizeSmall = 15.0;
  static const double iconSizeShare = 20.0;

}
  // -------------------------------------------------------------------------//
