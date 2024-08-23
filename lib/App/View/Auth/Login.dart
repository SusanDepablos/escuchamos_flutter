import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart'; // Asegúrate de ajustar la ruta
import 'package:escuchamos_flutter/Api/Service/AuthService.dart'; // Asegúrate de ajustar la ruta
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Input.dart';
import 'package:escuchamos_flutter/App/Widget/Button.dart';
import 'package:escuchamos_flutter/App/Widget/Label.dart'; 
import 'package:escuchamos_flutter/App/Widget/Logo.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _submitting = false;

  final Map<String, TextEditingController> _inputControllers = {
    'username': TextEditingController(),
    'password': TextEditingController(),
  };

  final Map<String, Color> _borderColors = {
    'username': Colors.grey,
    'password': Colors.grey,
  };

  final Map<String, String?> _errorMessages = {
    'username': null,
    'password': null,
  };

  Future<void> _call() async {
    setState(() {
      _submitting = true;
    });

    try {
      var response = await UserCommandLogin(UserLogin()).execute(
        context,
        _inputControllers['username']!.text,
        _inputControllers['password']!.text,
      );

      if (response is ValidationResponse) {
        if (response.key['username'] != null) {
          setState(() {
            _borderColors['username'] = Colors.red;
            _errorMessages['username'] = response.message('username');
          });
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _borderColors['username'] = Colors.grey;
              _errorMessages['username'] = null;
            });
          });
        }

        if (response.key['password'] != null) {
          setState(() {
            _borderColors['password'] = Colors.red;
            _errorMessages['password'] = response.message('password');
          });
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _borderColors['password'] = Colors.grey;
              _errorMessages['password'] = null;
            });
          });
        }
      } else if (response is SuccessResponse) {

        // Navegar a la pantalla Home con los datos
        Navigator.pushReplacementNamed(
          context,
          'home',
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: response is InternalServerError ? 'Error' : response is ApiError ? 'Error de Conexión' : 'Credenciales incorrectas',
            message: response.message,
          ),
        );
      }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error',
            message: e.toString(),
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      appBar: AppBar(
      backgroundColor: Colors.white, // Establece el fondo del AppBar a blanco
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: SingleChildScrollView( // Permite el desplazamiento
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Logo(size: 150.0),
              SizedBox(height: 28.0),
              GenericInput(
                text: 'Usuario',
                input: _inputControllers['username']!,
                border: _borderColors['username']!,
                error: _errorMessages['username'],
              ),
              SizedBox(height: 16.0),
              GenericInput(
                text: 'Contraseña',
                input: _inputControllers['password']!,
                obscureText: true,
                border: _borderColors['password']!,
                error: _errorMessages['password'],
              ),
              SizedBox(height: 28.0),
              GenericButton(
                label: 'Iniciar Sesión',
                onPressed: _call,
                isLoading: _submitting,
              ),
              Center(
              child: LabelRoute(
                name: 'Recuperar tú cuenta',
                route: 'recover-account',
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Center(
              child: LabelRoute(
                name: 'Crear cuenta nueva',
                route: 'register',
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}