import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart'; // Asegúrate de ajustar la ruta
import 'package:escuchamos_flutter/Api/Service/AuthService.dart'; // Asegúrate de ajustar la ruta
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Input.dart';
import 'package:escuchamos_flutter/App/Widget/Input.dart';
import 'package:escuchamos_flutter/App/Widget/Logo.dart';
import 'package:escuchamos_flutter/App/Widget/Button.dart';
import 'package:escuchamos_flutter/App/Widget/Label.dart'; 
import 'package:escuchamos_flutter/App/Widget/TermsAndConditionsCheckbox.dart'; 
import 'package:escuchamos_flutter/Constants/Constants.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _submitting = false;

  final Map<String, TextEditingController> _inputControllers = {
    'name': TextEditingController(),
    'username': TextEditingController(),
    'password': TextEditingController(),
    'email': TextEditingController(),
    'birthdate': TextEditingController(),
  };

  final Map<String, Color> _borderColors = {
    'name': Colors.grey,
    'username': Colors.grey,
    'password': Colors.grey,
    'email': Colors.grey,
    'birthdate': Colors.grey,
  };

  final Map<String, String?> _errorMessages = {
    'name': null,
    'username': null,
    'password': null,
    'email': null,
    'birthdate': null,
  };

  Future<void> _call() async {
    setState(() {
      _submitting = true;
    });

    try {
      var response = await UserCommandRegister(UserRegister()).execute(
        _inputControllers['name']!.text,
        _inputControllers['username']!.text,
        _inputControllers['password']!.text,
        _inputControllers['email']!.text,
        _inputControllers['birthdate']!.text,
      );

      if (response is ValidationResponse) {

        if (response.key['name'] != null) {
          setState(() {
            _borderColors['name'] = Colors.red;
            _errorMessages['name'] = response.message('name');
          });
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _borderColors['name'] = Colors.grey;
              _errorMessages['name'] = null;
            });
          });
        }

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

        if (response.key['email'] != null) {
          setState(() {
            _borderColors['email'] = Colors.red;
            _errorMessages['email'] = response.message('email');
          });
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _borderColors['email'] = Colors.grey;
              _errorMessages['email'] = null;
            });
          });
        }

        if (response.key['birthdate'] != null) {
          setState(() {
            _borderColors['birthdate'] = Colors.red;
            _errorMessages['birthdate'] = response.message('birthdate');
          });
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _borderColors['birthdate'] = Colors.grey;
              _errorMessages['birthdate'] = null;
            });
          });
        }

      } else if (response is SuccessResponse) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Success',
            message: response.message,
          ),
        ).then((_) {
          Navigator.pushNamed(
            context,
            'verify-code',
            arguments: _inputControllers['email']!.text,
          );

        });
      } else {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: response is ApiError ? 'Error de Conexión' : 'Error',
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
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(13.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogoBanner(size: MediaQuery.of(context).size.width),
            SizedBox(height: 8.0),
            GenericInput(
              text: 'Nombre y Apellido',
              input: _inputControllers['name']!,
              border: _borderColors['name']!,
              error: _errorMessages['name'],
            ),
            SizedBox(height: 16.0),
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
            SizedBox(height: 16.0),
            GenericInput(
              text: 'Correo electrónico',
              input: _inputControllers['email']!,
              border: _borderColors['email']!,
              error: _errorMessages['email'],
            ),
            SizedBox(height: 16.0),
            DateInput(
              text: 'Fecha de Nacimiento',
              input: _inputControllers['birthdate']!,
              border: _borderColors['birthdate']!,
              error: _errorMessages['birthdate'],
            ),
            SizedBox(height: 8.0),
            CustomCheckboxListTile(),
            SizedBox(height: 28.0),
            GenericButton(
              label: 'Registrarse',
              onPressed: _call,
              isLoading: _submitting,
            ),
            SizedBox(height: 8.0),
            LabelRoute(
              name: 'Iniciar sesión',
              route: 'login',
              color: AppColors.primaryBlue,
            ),
          ],
        ),
      ),
    ),
  );
}
}