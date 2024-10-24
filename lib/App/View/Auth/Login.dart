import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/Routes/Routes.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart'; // Asegúrate de ajustar la ruta
import 'package:escuchamos_flutter/Api/Service/AuthService.dart'; // Asegúrate de ajustar la ruta
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Service/NotificationLive.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Label.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Logo.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _submitting = false;

  final Map<String, TextEditingController> _inputControllers = {
    'username': TextEditingController(),
    'password': TextEditingController(),
  };

  final Map<String, Color> _borderColors = {
    'username': AppColors.inputBasic,
    'password': AppColors.inputBasic,
  };

  final Map<String, String?> _errorMessages = {
    'username': null,
    'password': null,
  };

  Future<void> _call() async {
    setState(() {
      _submitting = true;
    });

    try {
      var response = await UserCommandLogin(UserLogin()).execute(
        context,
        _inputControllers['username']!.text,
        _inputControllers['password']!.text,
      );

      if (response is ValidationResponse) {
        if (response.key['username'] != null) {
          setState(() {
            _borderColors['username'] = AppColors.inputDark;
            _errorMessages['username'] = response.message('username');
          });
          Future.delayed(const Duration(seconds: 2), () {
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
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _borderColors['password'] = AppColors.inputBasic;
              _errorMessages['password'] = null;
            });
          });
        }
      } else if (response is SuccessResponse) {
        NotificationService().fetchNotifications();
        Navigator.pushReplacementNamed(
          context,
          'base',
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
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: SingleChildScrollView(
          // Permite el desplazamiento
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Logo(size: 150.0),
              const SizedBox(height: 20.0),
              GenericInput(
                maxLength: 30,
                text: 'Usuario',
                input: _inputControllers['username']!,
                border: _borderColors['username']!,
                error: _errorMessages['username'],
              ),
              const SizedBox(height: 16.0),
              BasicInput(
                text: 'Contraseña',
                input: _inputControllers['password']!,
                obscureText: true,
                border: _borderColors['password']!,
                error: _errorMessages['password'],
              ),
              const SizedBox(height: 30.0),
              GenericButton(
                label: 'Iniciar Sesión',
                onPressed: _call,
                isLoading: _submitting,
              ),
              const SizedBox(height: 5.0),
              Center(
                child: BasicLabel(
                  name: 'Recuperar tú cuenta',
                  color: AppColors.black,
                  onTap: () {
                    Navigator.pushNamed(context, 'recover-account');
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              Center(
                child: BasicLabel(
                  name: 'Crear cuenta nueva',
                  color: AppColors.primaryBlue,
                  onTap: () {
                    // Ruta que deseas usar, por ejemplo, 'register'
                    String routeName = 'register';
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
                            var begin = const Offset(1.0,
                                0.0); // Empieza fuera de la pantalla a la derecha
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
