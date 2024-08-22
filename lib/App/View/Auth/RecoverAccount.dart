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

class RecoverAccount extends StatefulWidget {
  @override
  _RecoverAccountState createState() => _RecoverAccountState();
}

class _RecoverAccountState extends State<RecoverAccount> {
  bool _submitting = false;

  final Map<String, TextEditingController> _inputControllers = {
    'email': TextEditingController(),
  };

  final Map<String, Color> _borderColors = {
    'email': Colors.grey,
  };

  final Map<String, String?> _errorMessages = {
    'email': null,
  };

  Future<void> _call() async {
    setState(() {
      _submitting = true;
    });

    try {
      var response = await UserCommandRecoverAccount(Userrecoveraccount()).execute(
        _inputControllers['email']!.text,
      );


      if (response is ValidationResponse) {

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
        } else if (response is SuccessResponse) {
          Navigator.pushReplacementNamed(
            context,
            'recover-account-Verification',
            arguments: _inputControllers['email']!.text,
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
      backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LogoBanner(size: MediaQuery.of(context).size.width), 
              SizedBox(height: 28.0),
              LabelRoute(
                name: "Recupera tu cuenta",
                route: "", 
                color: Colors.black, 
              ),
              SizedBox(height: 8.0), 
              Text(
                'Introduce tu dirección de correo electrónico',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              GenericInput(
                text: 'Correo electrónico',
                input: _inputControllers['email']!,
                border: _borderColors['email']!,
                error: _errorMessages['email'],
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