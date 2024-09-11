import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Label.dart'; 
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Logo.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/DigitBox.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/CountTimer.dart'; 
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart'; 
import 'package:escuchamos_flutter/Api/Service/AuthService.dart'; 
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

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
      print(e);
      showDialog(
        context: context,
        builder: (context) => PopupWindow(
          title: 'Error de Flutter',
          message: 'Espera un poco, pronto lo solucionaremos.',
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
              'Verifica tu correo electrónico',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold, // Texto en negrita
                ),
              ),
            const SizedBox(height: 4.0), 
            const Text(
              'Escribe el código de 6 dígitos que enviamos a:',
              style: TextStyle(fontSize: 13.0),
            ),
            Text(
              widget.email,
              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 26.0), 
            DigitBox(
              input: _codeController, 
              border: Colors.blue, 
            ),
            const SizedBox(height: 20.0), 
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
            if (_isButtonEnabled)
              LabelActionWithDisable(
                text: "Reenviar código",
                onPressed: _isLoading ? () {} : _onResendCode,
                isLoading: _isLoading,
              ),
            const SizedBox(height: 25.0),
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

