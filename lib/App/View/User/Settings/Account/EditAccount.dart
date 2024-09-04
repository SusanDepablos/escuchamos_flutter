import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/Input.dart';
import 'package:escuchamos_flutter/App/Widget/Button.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
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

  final input = {
    'fieldUpdate': TextEditingController(),
  };

  final _borderColors = {
    'fieldUpdate': AppColors.inputBasic,
  };

  final Map<String, String?> _errorMessages = {
    'fieldUpdate': null,
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
              title: 'Error de Conexión',
              message: 'Error de conexión',
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error',
            message: 'Error: $e',
          ),
        );
      }
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
          builder: (context) => PopupWindow(
            title: 'Correcto',
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
          Future.delayed(Duration(seconds: 2), () {
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
              Text(
                widget.head ?? 'Configuración',
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  textAlign: TextAlign.left, // Alinea el texto a la izquierda
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                // El segundo texto se oculta si _textChanged; es true
                if (!widget.textChanged)
                  SizedBox(height: 1.0),
                  Text(
                    'Usuario actual: @${username ?? '...'}',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  )
              ],
            ),
            SizedBox(height: 10.0),
            GenericInput(
              text: widget.text,
              input: input['fieldUpdate']!,
              border: _borderColors['fieldUpdate']!,
              error: _errorMessages['fieldUpdate'],
            ),
            SizedBox(height: 32.0),
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
    );
  }
}
