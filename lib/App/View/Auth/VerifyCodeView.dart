import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart'; // Asegúrate de ajustar la ruta
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/CustomInput.dart';
import 'package:escuchamos_flutter/App/Widget/Logo.dart';
import 'package:escuchamos_flutter/App/Widget/CustomButton.dart';
import 'package:escuchamos_flutter/App/Widget/CustomLabel.dart'; 
import 'package:escuchamos_flutter/App/Widget/TermsAndConditionsCheckbox.dart'; 
import 'package:escuchamos_flutter/Constants/Constants.dart';

class VerifyCodeView extends StatefulWidget {
  final String email; // Añadido para recibir el parámetro email

  VerifyCodeView({required this.email});

  @override
  _VerifyCodeViewState createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  bool _submitting = false;

  final Map<String, TextEditingController> _inputControllers = {
    'verificationcode': TextEditingController(),
    'useremail': TextEditingController(),
  };

  final Map<String, Color> _borderColors = {
    'verificationcode': Colors.grey,
    'useremail': Colors.grey,
  };

  final Map<String, String?> _errorMessages = {
    'verificationcode': null,
    'useremail': null,
  };

  @override
  void initState() {
    super.initState();
    // Inicializa el campo de email con el valor recibido
    _inputControllers['email']!.text = widget.email;
  }

  Future<void> _call() async {
    setState(() {
      _submitting = true;
    });

    try {
      var response = await UserCommandVerifycode(UserVerifycode()).execute(
        _inputControllers['verificationcode']!.text,
        _inputControllers['useremail']!.text
      );

      if (response is ValidationResponse) {
        if (response.key['verificationcode'] != null) {
          setState(() {
            _borderColors['verificationcode'] = Colors.red;
            _errorMessages['verificationcode'] = response.message('verificationcode');
          });
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _borderColors['verificationcode'] = Colors.grey;
              _errorMessages['verificationcode'] = null;
            });
          });
        }

        if (response.key['useremail'] != null) {
          setState(() {
            _borderColors['useremail'] = Colors.red;
            _errorMessages['useremail'] = response.message('useremail');
          });
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _borderColors['useremail'] = Colors.grey;
              _errorMessages['useremail'] = null;
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
        ).then((_) { // Espera hasta que se cierre la ventana emergente
          Navigator.pushNamed(
            context,
            'login',
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
  void dispose() {
    // Asegúrate de limpiar los controladores al destruir el widget
    _inputControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, // Establece el fondo del AppBar a blanco
        elevation: 0, // Opcional: Quitar la sombra debajo del AppBar
        iconTheme: IconThemeData(color: Colors.black), // Cambia el color de los íconos a negro
        titleTextStyle: TextStyle(
          color: Colors.black, // Cambia el color del texto del título a negro
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: SingleChildScrollView( // Permite el desplazamiento
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LogoBanner(size: MediaQuery.of(context).size.width), // Ocupa todo el ancho
              SizedBox(height: 8.0),
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
              SizedBox(height: 8.0),
              CustomCheckboxListTile(),
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

