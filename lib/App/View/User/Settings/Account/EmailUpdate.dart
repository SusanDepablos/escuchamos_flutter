import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'dart:convert';

class EmailUpdate extends StatefulWidget {
  @override
  _EmailUpdateState createState() => _EmailUpdateState();
}

class _EmailUpdateState extends State<EmailUpdate> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  UserModel? _user;
  bool _submitting = false;
  String? username;
  String? name;
  bool password = true;
  bool email = false;
  String? userEmail;

  final _input = {
    'password': TextEditingController(),
    'email': TextEditingController(),
  };

  final _borderColors = {
    'password': AppColors.inputBasic,
    'email': AppColors.inputBasic,
  };

  final Map<String, String?> _errorMessages = {
    'password': null,
    'email': null,
  };

  Future<void> _callUser() async {
    final user = await _storage.read(key: 'user') ?? '0';
    final id = int.parse(user);
    final userCommand = UserCommandShow(UserShow(), id);

    try {
      final response = await userCommand.execute();

      if (mounted) {
        if (response is UserModel) {
          setState(() {
            _user = response;
            name = _user!.data.attributes.name;
            userEmail = _user!.data.attributes.email;
          });
        } else {
          showDialog(
            context: context,
            builder: (context) => PopupWindow(
              title: response is InternalServerError
                  ? 'Error'
                  : 'Error de Conexión',
              message: response.message,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error de Flutter',
            message: 'Espera un poco, pronto lo solucionaremos.',
          ),
        );
      }
    }
  }

  Future<void> _verifyPassword() async {
    setState(() {
      _submitting = true;
    });

    try {
      var response = await VerifyPasswordCommand(VerifyPasswords()).execute(
        _input['password']!.text,
      );

      if (response is SuccessResponse) {
        _input['password']!.clear();

        await showDialog(
          context: context,
          builder: (context) => AutoClosePopup(
            child: const SuccessAnimationWidget(), // Aquí se pasa la animación
            message: response.message,
          ),
        );

        password = false;
        email = true;
      } else if (response is ValidationResponse) {
        if (response.key['password'] != null) {
          setState(() {
            _borderColors['password'] = AppColors.inputDark;
            _errorMessages['password'] = response.message('password');
          });
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _borderColors['password'] = AppColors.inputBasic;
                _errorMessages['password'] = null;
              });
            }
          });
        }
      } else {
        await showDialog(
          context: context,
          builder: (context) => AutoClosePopupFail(
            child: const FailAnimationWidget(), // Aquí se pasa la animación
            message: response.message,
          ),
        );
      }
    } catch (e) {
      print(e);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error de Flutter',
            message: 'Espera un poco, pronto lo solucionaremos.',
          ),
        );
      }
    } finally {
      setState(() {
        _submitting = false;
      });
    }
  }

  Future<void> _updateEmail() async {
    setState(() {
      _submitting = true;
    });

    try {
      final body = jsonEncode({
        'email': _input['email']!.text,
      });

      var response =
          await AccountCommandUpdate(AccountUpdate()).execute(body: body);

      if (response is SuccessResponse) {
        await showDialog(
          context: context,
          builder: (context) => AutoClosePopup(
            child: const SuccessAnimationWidget(), // Aquí se pasa la animación
            message: response.message,
          ),
        );

        Navigator.pop(context);
      } else if (response is ValidationResponse) {
        if (response.key['email'] != null) {
          setState(() {
            _borderColors['email'] = AppColors.inputDark;
            _errorMessages['email'] = response.message('email');
          });
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _borderColors['email'] = AppColors.inputBasic;
              _errorMessages['email'] = null;
            });
          });
        }
      } else {
        await showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title:
                response is InternalServerError ? 'Error' : 'Error de Conexión',
            message: response.message,
          ),
        );
      }
    } catch (e) {
      print(e);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error de Flutter',
            message: 'Espera un poco, pronto lo solucionaremos.',
          ),
        );
      }
    } finally {
      setState(() {
        _submitting = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _callUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteapp,
      appBar: AppBar(
        backgroundColor: AppColors.whiteapp,
        centerTitle: true,
        title:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name ?? "...",
                style: const TextStyle(
                  fontSize: AppFond.title,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
                textScaleFactor: 1.0,
              ),
              const Text(
                'Configuración',
                style: TextStyle(
                  fontSize: AppFond.subtitle,
                  color: AppColors.inputDark,
                  fontStyle: FontStyle.italic,
                ),
                textScaleFactor: 1.0,
              ),
            ],
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Visibility(
              visible: password,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ingresa tu contraseña actual para cambiar el correo electrónico',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: AppFond.title,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                    textScaleFactor: 1.0,
                  ),
                  const SizedBox(height: 10.0),
                  BasicInput(
                    text: 'Contraseña actual',
                    input: _input['password']!,
                    obscureText: true,
                    border: _borderColors['password']!,
                    error: _errorMessages['password'],
                  ),
                  const SizedBox(height: 20.0),
                  GenericButton(
                    label: 'Verificar',
                    onPressed: () {
                      _verifyPassword();
                    },
                    isLoading: _submitting,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: email,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cambiar correo electrónico',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: AppFond.title,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                    textScaleFactor: 1.0,
                  ),
                  const SizedBox(height: 1.0),
                  Text(
                    'Correo actual: ${userEmail ?? '...'}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: AppFond.text,
                      color: AppColors.black,
                      fontStyle: FontStyle.italic,
                    ),
                    textScaleFactor: 1.0,
                  ),
                  const SizedBox(height: 10.0),
                  EmailInput(
                    text: 'Introduce tu nuevo correo',
                    input: _input['email']!,
                    border: _borderColors['email']!,
                    error: _errorMessages['email'],
                  ),
                  const SizedBox(height: 20.0),
                  GenericButton(
                    label: 'Actualizar',
                    onPressed: () {
                      _updateEmail();
                    },
                    isLoading: _submitting,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
