import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/Routes/Routes.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart'; // Asegúrate de ajustar la ruta
import 'package:escuchamos_flutter/Api/Service/AuthService.dart'; // Asegúrate de ajustar la ruta
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Logo.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/SimpleCheckbox.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Label.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/TermsAndConditions.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _submitting = false;
  bool _checkbox = false;

  final Map<String, TextEditingController> _inputControllers = {
    'name': TextEditingController(),
    'username': TextEditingController(),
    'password': TextEditingController(),
    'email': TextEditingController(),
    'birthdate': TextEditingController(),
  };

  final Map<String, Color> _borderColors = {
    'name': AppColors.inputBasic,
    'username': AppColors.inputBasic,
    'password': AppColors.inputBasic,
    'email': AppColors.inputBasic,
    'birthdate': AppColors.inputBasic,
  };

  final Map<String, String?> _errorMessages = {
    'name': null,
    'username': null,
    'password': null,
    'email': null,
    'birthdate': null,
    'checkbox': null
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
        _checkbox,
      );

      if (response is ValidationResponse) {
        if (response.key['name'] != null) {
          setState(() {
            _borderColors['name'] = AppColors.inputDark;
            _errorMessages['name'] = response.message('name');
          });
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              _borderColors['name'] = AppColors.inputBasic;
              _errorMessages['name'] = null;
            });
          });
        }

        if (response.key['username'] != null) {
          setState(() {
            _borderColors['username'] = AppColors.inputDark;
            _errorMessages['username'] = response.message('username');
          });
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              _borderColors['username'] = AppColors.inputBasic;
              _errorMessages['username'] = null;
            });
          });
        }

        if (response.key['password'] != null) {
          setState(() {
            _borderColors['password'] = AppColors.inputDark;
            _errorMessages['password'] = response.message('password');
          });
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              _borderColors['password'] = AppColors.inputBasic;
              _errorMessages['password'] = null;
            });
          });
        }

        if (response.key['email'] != null) {
          setState(() {
            _borderColors['email'] = AppColors.inputDark;
            _errorMessages['email'] = response.message('email');
          });
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              _borderColors['email'] = AppColors.inputBasic;
              _errorMessages['email'] = null;
            });
          });
        }

        if (response.key['birthdate'] != null) {
          setState(() {
            _borderColors['birthdate'] = AppColors.inputDark;
            _errorMessages['birthdate'] = response.message('birthdate');
          });
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              _borderColors['birthdate'] = AppColors.inputBasic;
              _errorMessages['birthdate'] = null;
            });
          });
        }

        if (response.key['checkbox'] != null) {
          setState(() {
            _errorMessages['checkbox'] = response.message('checkbox');
          });
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              _errorMessages['checkbox'] = null;
            });
          });
          setState(() {
            _submitting = false;
          });
        }
      } else if (response is SuccessResponse) {
        showDialog(
          context: context,
          builder: (context) => AutoClosePopup(
            child: const SuccessAnimationWidget(), // Aquí se pasa la animación
            message: response.message,
          ),
        ).then((_) {
          Navigator.pushReplacementNamed(
            context,
            'verify-code',
            arguments: _inputControllers['email']!.text,
          );
        });
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
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
        titleTextStyle: const TextStyle(
          color: AppColors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        title: LogoBanner(), // Aquí se inserta el LogoBanner en el AppBar
        centerTitle: true, // Para centrar el LogoBanner en el AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              GenericInput(
                maxLength: 35,
                text: 'Nombre y Apellido',
                input: _inputControllers['name']!,
                border: _borderColors['name']!,
                error: _errorMessages['name'],
              ),
              const SizedBox(height: 16.0),
              GenericInput(
                maxLength: 15,
                text: 'Usuario',
                input: _inputControllers['username']!,
                border: _borderColors['username']!,
                error: _errorMessages['username'],
              ),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BasicInput(
                    text: 'Contraseña',
                    input: _inputControllers['password']!,
                    obscureText: true,
                    border: _borderColors['password']!,
                    error: _errorMessages['password'],
                  ),
                  const SizedBox(height: 8), // Espacio entre el input y el texto explicativo
                  const Text(
                    'Tu contraseña debe incluir letras, números y tener al menos 8 caracteres.',
                    style: TextStyle(
                      color: AppColors.grey, // Color del texto explicativo
                      fontSize: AppFond.text, // Tamaño del texto
                      fontStyle: FontStyle.italic,
                    ),
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EmailInput(
                    text: 'Correo electrónico',
                    input: _inputControllers['email']!,
                    border: _borderColors['email']!,
                    error: _errorMessages['email'],
                  ),
                  const SizedBox(height: 8), // Espacio entre el input y el texto explicativo
                  const Text(
                    'Asegurate de ingresar un correo gmail activo, ya que recibirás un código de verificación.',
                    style: TextStyle(
                      color: AppColors.grey, // Color del texto explicativo
                      fontSize: AppFond.text, // Tamaño del texto
                      fontStyle: FontStyle.italic,
                    ),
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              DateInput(
                text: 'Fecha de Nacimiento',
                input: _inputControllers['birthdate']!,
                border: _borderColors['birthdate']!,
                error: _errorMessages['birthdate'],
              ),
              const SizedBox(height: 8.0),
              SimpleCheckbox(
                label: '', // Puedes dejarlo vacío, ya que vamos a usar RichText dentro del widget.
                labelColor: AppColors.black,
                onChanged: (bool isChecked) {
                  setState(() {
                    _checkbox = isChecked;
                  });
                },
                onLabelTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TermsAndConditions();
                    },
                  );
                },
                error: _errorMessages['checkbox'],
              ),
              const SizedBox(height: 20.0),
              GenericButton(
                label: 'Registrarse',
                onPressed: _call,
                isLoading: _submitting,
              ),
              const SizedBox(height: 5.0),
              Center(
                child: BasicLabel(
                  name: 'Iniciar sesión',
                  color: AppColors.primaryBlue,
                  onTap: () {
                    // Ruta que deseas usar, por ejemplo, 'login'
                    String routeName = 'login';

                    // Verifica si la ruta existe en AppRoutes
                    if (AppRoutes.routes.containsKey(routeName)) {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(
                              milliseconds: 400), // Duración de la animación
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  AppRoutes.routes[routeName]!(context),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = const Offset(-1.0,
                                0.0); // Empieza fuera de la pantalla a la izquierda
                            var end = Offset
                                .zero; // Termina en el centro de la pantalla
                            var curve = Curves.easeInOut;
                            var slideTween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var fadeTween = Tween(begin: 0.0, end: 1.0)
                                .chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(slideTween),
                              child: FadeTransition(
                                opacity: animation.drive(fadeTween),
                                child: ScaleTransition(
                                  scale: Tween<double>(begin: 0.95, end: 1.0)
                                      .animate(animation),
                                  child: child,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      //print('Ruta no encontrada: $routeName');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
