import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
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
      var response =
          await UserCommandRecoverAccount(Userrecoveraccount()).execute(
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
          builder: (context) => AutoClosePopupFail(
            child: const FailAnimationWidget(), // Aquí se pasa la animación
            message: response.message,
          ),
        );
      }
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) => PopupWindow(
          title: 'Error de Flutter',
          message: 'Espera un poco, pronto lo solucionaremos.',
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
        title: Row(
          children: [
            Center(
              child: LogoBanner(),
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
              const SizedBox(height: 20.0),
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
