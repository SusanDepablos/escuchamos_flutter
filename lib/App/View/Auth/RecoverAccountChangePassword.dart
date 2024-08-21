import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/CustomLabel.dart'; 
import 'package:escuchamos_flutter/App/Widget/Logo.dart';
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart'; 
import 'package:escuchamos_flutter/Api/Service/AuthService.dart'; 
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/App/Widget/CustomButton.dart';
import 'package:escuchamos_flutter/App/Widget/CustomInput.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart'; 

class RecoverAccountChangePassword extends StatefulWidget {
    final String email;

    RecoverAccountChangePassword({required this.email});

  @override
  _RecoverAccountChangePasswordState createState() => _RecoverAccountChangePasswordState();
}

class _RecoverAccountChangePasswordState extends State<RecoverAccountChangePassword> {
  bool _submitting = false;

  final Map<String, TextEditingController> _inputControllers = {
    'password': TextEditingController(),
  };

  final Map<String, Color> _borderColors = {
    'password': Colors.grey,
  };

  final Map<String, String?> _errorMessages = {
    'password': null,
  };

  Future<void> _call() async {
    setState(() {
      _submitting = true;
    });

    try {
      var response = await UserCommandUserRecoverAccountChangePassword(UserRecoverAccountChangePassword()).execute(
        widget.email,
        _inputControllers['password']!.text,
      );


      if (response is ValidationResponse) {
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
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Éxito',
            message: response.message,
          ),
        ).then((_) {
          // Navegar a la ruta de login después de cerrar el diálogo
          Navigator.pushReplacementNamed(context, 'login');
        });
      }  else {
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
              LogoBanner(size: MediaQuery.of(context).size.width), 
              SizedBox(height: 28.0),
              Label(
                name: "Restablece tu contraseña",
                route: "", 
                color: Colors.black, 
              ),
              SizedBox(height: 8.0), 
              Text(
                'las contraseñas fuertes incluyen números, letras y signos de puntuación',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              CustomInput(
                text: 'Introduce tu contraseña nueva',
                input: _inputControllers['password']!,
                border: _borderColors['password']!,
                error: _errorMessages['password'],
              ),
              SizedBox(height: 28.0),
              CustomButton(
                label: 'Enviar',
                onPressed: _call,
                isLoading: _submitting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}