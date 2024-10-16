import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart';
import 'package:escuchamos_flutter/Api/Service/AuthService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/ShowConfirmationDialog.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
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
import 'dart:convert';

class Delete extends StatefulWidget {
  @override
  _DeleteState createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  UserModel? _user;
  bool _submitting = false;
  String? username;
  String? name;
  bool password = true;
  bool email = false;

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
            username = _user!.data.attributes.username;
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
      // Llamar a la función de confirmación para cerrar sesión
      _showDeleteUserConfirmation(context);
      
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
        builder: (context) => PopupWindow(
          title: response is InternalServerError ? 'Error' : 'Error de Conexión',
          message: response.message,
        ),
      );
    }
  } catch (e) {
    await showDialog(
      context: context,
      builder: (context) => PopupWindow(
        title: 'Error',
        message: e.toString(),
      ),
    );
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
          builder: (context) => PopupWindow(
            title: 'Correcto',
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
          Future.delayed(Duration(seconds: 2), () {
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


  void _showDeleteUserConfirmation(BuildContext context) {
    showConfirmationDialog(
      context,
      title: 'Eliminar Cuenta',
      content: '¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer.',
      onConfirmTap: () async {
        await _deleteUser(); // Llama a la función de cierre de cuenta  
      },
    );
  }

  Future<void> _deleteUser() async {
    // Obtén el ID del usuario antes de cerrar sesión
    final user = await _storage.read(key: 'user') ?? '0';
    final token = await _storage.read(key: 'token') ?? '';
    final id = int.parse(user);

    // Primero, cierra sesión
    _logout(context);

    // Luego, procede a eliminar el usuario usando el ID que guardaste
    try {
      var response = await DeleteCommandUser(DeleteUser()).execute(id: id , token: token);

      if (response is SuccessResponse) {
        // Redirige al usuario a la pantalla de login

      } else {
        await showDialog(
          context: context,
          builder: (context) => AutoClosePopupFail(
            child: const FailAnimationWidget(),
            message: response.message,
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => PopupWindow(
          title: 'Error',
          message: 'Espera un poco, pronto lo solucionaremos.',
        ),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    setState(() {
      _submitting = true;
    });
    final userCommandLogout = UserCommandLogout(UserLogout());

    try {
      // Ejecutar el comando de cierre de sesión
      final response = await userCommandLogout.execute();

      if (response is SuccessResponse) {
        await showDialog(
          context: context,
          builder: (context) => AutoClosePopup(
            child: const LogoutAnimationWidget(),
            message: response.message,
          ),
        );
        // Elimina el token y otros datos del almacenamiento seguro
        await _clearSecureStorage();
        Navigator.pushNamedAndRemoveUntil(
          context,
          'login',
          (route) => false,
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error',
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

  // Método separado para limpiar el almacenamiento seguro
  Future<void> _clearSecureStorage() async {
    try {
      await _storage.delete(key: 'token');
      await _storage.delete(key: 'session_key');
      await _storage.delete(key: 'user');
      await _storage.delete(key: 'groups');
    } catch (e) {
      print('Error al eliminar datos del almacenamiento seguro: $e');
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error',
            message: 'No se pudo cerrar la sesión correctamente. Por favor intenta de nuevo.',
          ),
        );
      }
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
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ingresa tú contraseña actual',
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
                    color: AppColors.errorRed,
                    label: 'Eliminar',
                    onPressed: () {
                      _verifyPassword();
                    },
                    isLoading: _submitting,
                  ),
                ],
            ),
          ],
        ),
      ),
    );
  }
}
