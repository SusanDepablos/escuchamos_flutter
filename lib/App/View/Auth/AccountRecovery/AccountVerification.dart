import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Label.dart'; 
import 'package:escuchamos_flutter/App/Widget/Ui/CountTimer.dart'; 
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Logo.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart'; 
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart'; 
import 'package:escuchamos_flutter/Api/Service/AuthService.dart'; 
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class RecoverAccountVerification extends StatefulWidget {
  final String email;

  RecoverAccountVerification({required this.email});

  @override
  _RecoverAccountVerificationState createState() => _RecoverAccountVerificationState();
}

class _RecoverAccountVerificationState extends State<RecoverAccountVerification> {
  final TextEditingController _codeController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  bool _isConfirmLoading = false;

  Future<void> _onResendCode() async {
    setState(() {
      _isLoading = true;
    });

    UserCommandRecoverAccount command = UserCommandRecoverAccount(Userrecoveraccount());
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
      UserCommandRecoverAccountVerification command = UserCommandRecoverAccountVerification(UserRecoverAccountVerification());
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
          Navigator.pushReplacementNamed(
                context,
                'change-password',
                arguments: widget.email,
              );
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
      backgroundColor: AppColors.whiteapp,
      appBar: AppBar(
        backgroundColor: AppColors.whiteapp, 
        automaticallyImplyLeading: false,
      title: LogoBanner(), // Aquí se inserta el LogoBanner en el AppBar
        centerTitle: true, // Para centrar el LogoBanner en el AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Text(
                'Verifica tu Correo Electrónico',
                style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold, // Texto en negrita
                ),
              ),
            const SizedBox(height: 8.0), 
            const Text(
              'Escribe el código de 8 dígitos que enviamos a:',
              style: TextStyle(fontSize: 13.0),
            ),
            Text(
              widget.email,
              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 26.0), 
            SecureInput(
              text: 'Ingrese código',
              input: _codeController,
            ),
            const SizedBox(height: 16.0), 
            const Text(
              'Puedes solicitar un nuevo código en:',
              style: TextStyle(fontSize: 14.0, color: Colors.black),
            ),
            Align(
              alignment: Alignment.center, // Puedes ajustar esto para alinear en cualquier lugar
              child: CountTimer(
                onTimerEnd: _enableButton,
              ),
            ),
            const SizedBox(height: 2.0),
            if (_isButtonEnabled)
              Center(
              child: LabelAction(
                text: "Reenviar código",
                onPressed: _isLoading ? () {} : _onResendCode,
                isLoading: _isLoading,
              ),
            ),
            const SizedBox(height: 16.0),
            GenericButton(
              label: "Verificar",
              onPressed: _isConfirmLoading ? () {} : _onConfirmCode,
              isLoading: _isConfirmLoading,
            ),
          ],
        ),
      ),
    );
  }
}

