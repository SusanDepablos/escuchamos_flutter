import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
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

class EditAccount extends StatefulWidget {
  final String text;
  final String label;
  final bool textChanged;
  final String? head;
  final String field;

  EditAccount(
      {required this.text,
      required this.label,
      this.textChanged = true,
      this.head,
      required this.field});

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<EditAccount> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  UserModel? _user;
  bool _submitting = false;
  String? username;
  String? name;
  bool password = true;
  bool _username = false;
  String? userEmail;
  int? groupId;
  bool isVerified = false;

  final input = {
    'fieldUpdate': TextEditingController(),
    'password': TextEditingController(),
  };

  final _borderColors = {
    'fieldUpdate': AppColors.inputBasic,
    'password': AppColors.inputBasic,
  };

  final Map<String, String?> _errorMessages = {
    'fieldUpdate': null,
    'password': null,
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
            userEmail = _user!.data.attributes.email;
            groupId = _user!.data.relationships.groups[0].id;
            isVerified = groupId == 1 || groupId == 2;
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
        input['password']!.text,
      );

      if (response is SuccessResponse) {
        input['password']!.clear();

        await showDialog(
          context: context,
          builder: (context) => AutoClosePopup(
            child: const SuccessAnimationWidget(), // Aquí se pasa la animación
            message: response.message,
          ),
        );

        password = false;
        _username = true;
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

  Future<void> _updateField() async {
    setState(() {
      _submitting = true;
    });

    try {
      final body = jsonEncode({
        widget.field: input['fieldUpdate']!.text,
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
        if (response.key[widget.field] != null) {
          setState(() {
            _borderColors['fieldUpdate'] = AppColors.inputDark;
            _errorMessages['fieldUpdate'] = response.message(widget.field);
          });
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _borderColors['fieldUpdate'] = AppColors.inputBasic;
              _errorMessages['fieldUpdate'] = null;
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
              Text(
                widget.head ?? 'Configuración',
                style: const TextStyle(
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
                    'Ingresa tu contraseña actual para cambiar tú usuario',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: AppFond.subtitle + 1,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                    textScaleFactor: 1.0,
                  ),
                  const SizedBox(height: 10.0),
                  BasicInput(
                    text: 'Contraseña actual',
                    input: input['password']!,
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
              visible: _username,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    textAlign: TextAlign.left, // Alinea el texto a la izquierda
                    style: const TextStyle(
                      fontSize: AppFond.title,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                    textScaleFactor: 1.0,
                  ),
                  // El segundo texto se oculta si _textChanged; es true
                  if (!widget.textChanged) const SizedBox(height: 1.0),
                  Row(
                    children: [
                      Text(
                        'Usuario actual: ${username ?? '...'}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: AppFond.text,
                          color: AppColors.black,
                          fontStyle: FontStyle.italic,
                        ),
                        textScaleFactor: 1.0,
                      ),
                      const SizedBox(width: 4), // Espaciado entre el texto y el ícono
                      if (isVerified)
                        const Icon(
                          CupertinoIcons.checkmark_seal_fill, // Cambia este ícono según tus necesidades
                          color: AppColors.primaryBlue, // Color del ícono
                          size: AppFond.iconVerified - 2, // Tamaño del ícono
                        ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  GenericInput(
                    maxLength: 15,
                    text: widget.text,
                    input: input['fieldUpdate']!,
                    border: _borderColors['fieldUpdate']!,
                    error: _errorMessages['fieldUpdate'],
                  ),
                  const SizedBox(height: 20.0),
                  GenericButton(
                    label: 'Actualizar',
                    onPressed: () {
                      _updateField();
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
