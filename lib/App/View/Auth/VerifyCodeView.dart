import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/Label.dart'; 
import 'package:escuchamos_flutter/App/Widget/Logo.dart';
import 'package:escuchamos_flutter/App/Widget/Input.dart'; 
import 'package:escuchamos_flutter/App/Widget/DigitBox.dart';
import 'package:escuchamos_flutter/App/Widget/CountTimer.dart'; 
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart'; 
import 'package:escuchamos_flutter/Api/Service/AuthService.dart'; 
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/App/Widget/Button.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart';

class VerifyCodeView extends StatefulWidget {
  final String email;

  VerifyCodeView({required this.email});

  @override
  _VerifyCodeViewState createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  final TextEditingController _codeController = TextEditingController();
  bool _isButtonEnabled = false; 
  bool _isLoading = false;
  bool _isConfirmLoading = false;

  Future<void> _onResendCode() async {
    setState(() {
      _isLoading = true;
    });

    UserCommandResendCode command = UserCommandResendCode(UserResendCode());
    var response = await command.execute(widget.email);

    setState(() {
      _isLoading = false;
    });

    if (response is SuccessResponse) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Código reenviado con éxito')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al reenviar el código')),
      );
    }
  }

  Future<void> _onConfirmCode() async {
    setState(() {
      _isConfirmLoading = true;
    });

    try {
      UserCommandVerifycode command = UserCommandVerifycode(UserVerifycode());
      var response = await command.execute(_codeController.text, widget.email);

      setState(() {
        _isConfirmLoading = false;
      });

      if (response is SuccessResponse) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Éxito',
            message: response.message,
          ),
        ).then((_) {

          Navigator.pushReplacementNamed(context, 'login');
        });
      } else if (response is SimpleErrorResponse) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error',
            message: response.message,
          ),
        );
      } else if (response is InternalServerError) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error interno del servidor',
            message: response.message,
          ),
        );
      } else if (response is ApiError) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error de conexión',
            message: 'No se pudo conectar con el servidor',
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error desconocido',
            message: 'Ocurrió un error desconocido',
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isConfirmLoading = false;
      });

      showDialog(
        context: context,
        builder: (context) => PopupWindow(
          title: 'Error',
          message: 'Error: ${e.toString()}',
        ),
      );
    }
  }

  void _enableButton() {
    setState(() {
      _isButtonEnabled = true;
    });
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogoBanner(size: MediaQuery.of(context).size.width), 
            SizedBox(height: 8.0), 
            LabelRoute(
              name: "Verifica tu correo electrónico",
              route: "", 
              color: Colors.black, 
            ),
            SizedBox(height: 8.0), 
            Text(
              'Escribe el código de 6 dígitos que enviamos a:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              widget.email,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 26.0), 
            DigitBox(
              input: _codeController, 
              border: Colors.blue, 
            ),
            SizedBox(height: 16.0), 
            Text(
              'Puedes solicitar un nuevo código en:',
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            CountTimer(
              onTimerEnd: _enableButton,
            ),
            SizedBox(height: 16.0),
            if (_isButtonEnabled)
              LabelAction(
                text: "Reenviar código",
                onPressed: _isLoading ? () {} : _onResendCode,
                isLoading: _isLoading,
              ),
            SizedBox(height: 32.0),
            GenericButton(
              label: "Confirmar correo",
              onPressed: _isConfirmLoading ? () {} : _onConfirmCode,
              isLoading: _isConfirmLoading,
            ),
          ],
        ),
      ),
    );
  }
}
