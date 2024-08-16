import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart'; // Asegúrate de ajustar la ruta
import 'package:escuchamos_flutter/Api/Service/AuthService.dart'; // Asegúrate de ajustar la ruta
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/CustomInput.dart';
import 'package:escuchamos_flutter/App/Widget/CustomDateInput.dart';
import 'package:escuchamos_flutter/App/Widget/Logo.dart';
import 'package:escuchamos_flutter/App/Widget/CustomButton.dart';
import 'package:escuchamos_flutter/App/Widget/CustomLabel.dart'; 
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
        // Navegar a la pantalla Home con los datos
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Success',
            message: response.message,
          ),
        );
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
    appBar: AppBar(),
    body: Padding(
      padding: const EdgeInsets.all(13.0),
      child: SingleChildScrollView( // Permite el desplazamiento
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogoBanner(size: MediaQuery.of(context).size.width), // Ocupa todo el ancho
            SizedBox(height: 8.0), // Puedes reducir este espacio o eliminarlo
            CustomInput(
              text: 'Nombre y Apellido',
              input: _inputControllers['name']!,
              border: _borderColors['name']!,
              error: _errorMessages['name'],
            ),
            SizedBox(height: 16.0),
            CustomInput(
              text: 'Usuario',
              input: _inputControllers['username']!,
              border: _borderColors['username']!,
              error: _errorMessages['username'],
            ),
            SizedBox(height: 16.0),
            CustomInput(
              text: 'Contraseña',
              input: _inputControllers['password']!,
              obscureText: true,
              border: _borderColors['password']!,
              error: _errorMessages['password'],
            ),
            SizedBox(height: 16.0),
            CustomInput(
              text: 'Correo electrónico',
              input: _inputControllers['email']!,
              border: _borderColors['email']!,
              error: _errorMessages['email'],
            ),
            SizedBox(height: 16.0),
            CustomDateInput(
              text: 'Fecha de Nacimiento',
              input: _inputControllers['birthdate']!,
              border: _borderColors['birthdate']!,
              error: _errorMessages['birthdate'],
            ),
            SizedBox(height: 8.0),
            Label(
              name: 'Aceptar términos y condiciones',
              route: '',
              color: AppColors.black,
            ),
            SizedBox(height: 28.0),
            CustomButton(
              label: 'Registrarse',
              onPressed: _call,
              isLoading: _submitting,
            ),
            SizedBox(height: 8.0),
            Label(
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