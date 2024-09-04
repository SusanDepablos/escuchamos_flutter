import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class ApiUrl{
  // ---------------------------URL base de la API ---------------------------//

  //url para pruebas en el servidor:
  static const String baseUrl = 'https://escuchamos-mcu6.onrender.com/api/';

  // -------------------------------------------------------------------------//

  //paginas:
  static const String WebSite = 'https://escuchamos-mcu6.onrender.com/';
  static const String Facebook= 'https://www.facebook.com/ProyectosEscuChamos';
  static const String Correo = '';



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
}
  // -------------------------------------------------------------------------//

class AppFond {
  static const double title = 20.0; // Tamaño de letra para el título
  static const double subtitle = 14.0; // Tamaño de letra para el subtítulo
}


  // -------------------------------------------------------------------------//

  // -------------------------------------------------------------------------//

class UserSession {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static String? _token;
  static String? _session_key;
  static String? _user;
  static List<dynamic>? _groups;

  static Future<void> _initialize() async {
    if (_token == null) {
      final token = await _storage.read(key: 'token') ?? '';
      final session_key = await _storage.read(key: 'session_key') ?? '';
      final user = await _storage.read(key: 'user') ?? '';
      final groupsString = await _storage.read(key: 'groups') ?? '[]';
      final groups = (groupsString.isNotEmpty)
          ? List<dynamic>.from(json.decode(groupsString))
          : [];

      _token = token;
      _session_key = session_key;
      _user = user;
      _groups = groups;
    }
  }

  static String get token {
    _initializeSync();
    return _token ?? '';
  }

  static String get session_key {
    _initializeSync();
    return _session_key ?? '';
  }

  static String get user {
    _initializeSync();
    return _user ?? '';
  }

  static List<dynamic> get groups {
    _initializeSync();
    return _groups ?? [];
  }

  static void _initializeSync() {
    if (_token == null) {
      _initialize();
    }
  }
}

//    print(UserSession.token);
//    print(UserSession.session_key);
//    print(UserSession.user);
//    print(UserSession.groups);
  // -------------------------------------------------------------------------//