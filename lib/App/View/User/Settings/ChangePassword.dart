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
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';

class UserChangePassword extends StatefulWidget {
  @override
  _UserChangePasswordState createState() => _UserChangePasswordState();
}

class _UserChangePasswordState extends State<UserChangePassword> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  UserModel? _user;
  bool _submitting = false;
  String? name;
  String? old_password;
  String? new_password;

  final _input = {
    'old_password': TextEditingController(),
    'new_password': TextEditingController(),
  };

  final _borderColors = {
    'old_password': AppColors.inputBasic,
    'new_password': AppColors.inputBasic,
  };

  final Map<String, String?> _errorMessages = {
    'old_password': null,
    'new_password': null,
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

  Future<void> _changePassword() async {
    setState(() {
      _submitting = true;
    });

    try {
      var response = await ChangePasswordCommand(ChangePassword()).execute(
        _input['old_password']!.text,
        _input['new_password']!.text,
      );

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
        if (response.key['old_password'] != null) {
          setState(() {
            _borderColors['old_password'] = AppColors.inputDark;
            _errorMessages['old_password'] = response.message('old_password');
          });
          Future.delayed(Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _borderColors['old_password'] = AppColors.inputBasic;
                _errorMessages['old_password'] = null;
              });
            }
          });
        }
        if (response.key['new_password'] != null) {
          setState(() {
            _borderColors['new_password'] = AppColors.inputDark;
            _errorMessages['new_password'] = response.message('new_password');
          });
          Future.delayed(Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _borderColors['new_password'] = AppColors.inputBasic;
                _errorMessages['new_password'] = null;
              });
            }
          });
        }
      } else {
        await showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: response is InternalServerError
                ? 'Error'
                : response is ApiError
                    ? 'Error de Conexión'
                    : 'Contraseña incorrecta',
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
              ),
              const Text(
                'Cambiar contraseña',
                style: TextStyle(
                  fontSize: AppFond.subtitle,
                  color: AppColors.inputDark,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20.0),
            BasicInput(
              text: 'Contraseña actual',
              input: _input['old_password']!,
              obscureText: true,
              border: _borderColors['old_password']!,
              error: _errorMessages['old_password'],
            ),
            const SizedBox(height: 20.0),
            BasicInput(
              text: 'Contraseña nueva',
              input: _input['new_password']!,
              obscureText: true,
              border: _borderColors['new_password']!,
              error: _errorMessages['new_password'],
            ),
            const SizedBox(height: 20.0),
            GenericButton(
              label: 'Actualizar',
              onPressed: () {
                _changePassword();
              },
              isLoading: _submitting,
            ),
          ],
        ),
      ),
    );
  }
}
