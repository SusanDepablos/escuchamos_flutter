import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/Label.dart'; 
import 'package:escuchamos_flutter/App/Widget/Logo.dart';
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart'; 
import 'package:escuchamos_flutter/Api/Service/AuthService.dart'; 
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/App/Widget/Button.dart';
import 'package:escuchamos_flutter/App/Widget/Input.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart'; 
import 'package:escuchamos_flutter/Constants/Constants.dart';

class RecoverAccountChangePassword extends StatefulWidget {
  final String email;

  RecoverAccountChangePassword({required this.email});

  @override
  _RecoverAccountChangePasswordState createState() => _RecoverAccountChangePasswordState();
}

class _RecoverAccountChangePasswordState extends State<RecoverAccountChangePassword> {
  bool _submitting = false;

  final Map<String, TextEditingController> _inputControllers = {
    'new_password': TextEditingController(),
  };

  final Map<String, Color> _borderColors = {
    'new_password': AppColors.inputBasic,
  };

  final Map<String, String?> _errorMessages = {
    'new_password': null,
  };

  Future<void> _call() async {
    setState(() {
      _submitting = true;
    });

    try {
      var response = await UserCommandUserRecoverAccountChangePassword(UserRecoverAccountChangePassword()).execute(
        widget.email,
        _inputControllers['new_password']!.text,
      );

      if (response is ValidationResponse) {

        if (response.key['new_password'] != null) {
          setState(() {
            _borderColors['new_password'] = AppColors.inputDark;
            _errorMessages['new_password'] = response.message('new_password');
          });
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _borderColors['new_password'] = AppColors.inputBasic;
              _errorMessages['new_password'] = null;
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

            Navigator.pushReplacementNamed(context, 'login');
          });
        } else {
          showDialog(
            context: context,
            builder: (context) => PopupWindow(
              title: response is InternalServerError ? 'Error' : response is ApiError ? 'Error de Conexión' : 'Contraseña Inválida',
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
        automaticallyImplyLeading: false,
      title: LogoBanner(), // Aquí se inserta el LogoBanner en el AppBar
        centerTitle: true, // Para centrar el LogoBanner en el AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(
                'Actualizar tu Contraseña',
                style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold, // Texto en negrita
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                style: TextStyle(fontSize: 13.0),
                'Las contraseñas fuertes incluyen números, letras y signos de puntuación. Mínimo 8 dígitos.',
              ),
              SizedBox(height: 16.0),
              BasicInput(
                text: 'Introduce tu contraseña nueva',
                input: _inputControllers['new_password']!,
                obscureText: true,
                border: _borderColors['new_password']!,
                error: _errorMessages['new_password'],
              ),
              SizedBox(height: 28.0),
              GenericButton(
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