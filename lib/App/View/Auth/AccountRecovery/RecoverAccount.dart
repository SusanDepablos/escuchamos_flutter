import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Logo.dart';
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart'; 
import 'package:escuchamos_flutter/Api/Service/AuthService.dart'; 
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart'; 
import 'package:escuchamos_flutter/Constants/Constants.dart';

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
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _borderColors['email'] = Colors.grey;
              _errorMessages['email'] = null;
            });
          });
        }
        } else if (response is SuccessResponse) {
          Navigator.pushReplacementNamed(
            context,
            'account-verification',
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
    backgroundColor: AppColors.whiteapp,
      appBar: AppBar(
        backgroundColor: AppColors.whiteapp,
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            // Este Positioned coloca el ícono de retroceso en el lado izquierdo
            Positioned(
              left: 0,
              top: 9, // Ajusta este valor para controlar cuánto quieres bajar el ícono
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () {
                  Navigator.pop(context); // Esto regresa a la pantalla anterior
                },
              ),
            ),
            // Este Center centra el LogoBanner en el AppBar
            Center(
              child: LogoBanner(), // Aquí se inserta el LogoBanner centrado
            ),
          ],
        ),
        centerTitle: true, // Mantiene el título centrado visualmente
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recupera tu cuenta',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold, // Texto en negrita
                ),
              ),
              const SizedBox(height: 4.0), 
              const Text(
                'Introduce tu dirección de correo electrónico',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              GenericInput(
                text: 'Correo electrónico',
                input: _inputControllers['email']!,
                border: _borderColors['email']!,
                error: _errorMessages['email'],
              ),
              const SizedBox(height: 28.0),
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

