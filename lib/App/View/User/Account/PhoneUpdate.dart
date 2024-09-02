import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:escuchamos_flutter/App/Widget/Input.dart';
import 'package:escuchamos_flutter/App/Widget/Button.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Command/CountryCommand.dart';
import 'package:escuchamos_flutter/Api/Service/CountryService.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/Api/Model/CountryModels.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Select.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'dart:convert';

class PhoneUpdate extends StatefulWidget {
  @override
  _PhoneUpdateState createState() => _PhoneUpdateState();
}

class _PhoneUpdateState extends State<PhoneUpdate> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  List<String?> dialingCode = [];
  UserModel? _user;
  bool _submitting = false;
  String? username;
  String? name;
  String? _selected;
  bool _isInputEnabled = false; // Estado del NumericInput
  bool _isButtonLocked = true; // Estado del LockableButton

  final input = {
    'phone_number': TextEditingController(),
  };

  final _borderColors = {
    'phone_number': AppColors.inputBasic,
  };

  final Map<String, String?> _errorMessages = {
    'phone_number': null,
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

  Future<void> _callCountries() async {
    final countryCommand = CountryCommandIndex(CountryIndex());

    try {
      var response = await countryCommand.execute();

      if (mounted) {
        if (response is CountriesModel) {
          setState(() {
            dialingCode = response.data
                .map((datum) => datum.attributes.dialingCode)
                .toSet()
                .toList();

            if (_selected != null && !dialingCode.contains(_selected)) {
              _selected = null;
            }
            _updateFieldState(); // Actualiza el estado del campo y del botón
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
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error',
            message: e.toString(),
          ),
        );
      }
    }
  }

  void _updateFieldState() {
    // Actualiza el estado de habilitación del NumericInput y del LockableButton
    setState(() {
      _isInputEnabled = _selected != null && _selected!.isNotEmpty;
      _isButtonLocked =
          !(_isInputEnabled && input['phone_number']!.text.isNotEmpty);
    });
  }

  Future<void> _updateField() async {
    setState(() {
      _submitting = true;
    });

    try {
      final body = jsonEncode({
        'phone_number': '$_selected ${input['phone_number']!.text}',
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
        if (response.key['phone_number'] != null) {
          setState(() {
            _borderColors['phone_number'] = AppColors.inputDark;
            _errorMessages['phone_number'] = response.message('phone_number');
          });
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _borderColors['phone_number'] = AppColors.inputBasic;
              _errorMessages['phone_number'] = null;
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
    _callCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                'Configuración',
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
                  'Cambiar número telefónico',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Select(
                    selectedValue: _selected,
                    items: dialingCode,
                    hintText: '+0',
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                    ),
                    dropdownColor: Colors.white,
                    iconSize: 0,
                    onChanged: (value) {
                      setState(() {
                        _selected = value;
                        _updateFieldState(); // Actualiza el estado del campo y del botón
                      });
                    },
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: NumericInput(
                    text: 'Introduce tu nuevo número telefónico',
                    input: input['phone_number']!,
                    border: _borderColors['phone_number']!,
                    error: _errorMessages['phone_number'],
                    isDisabled:
                        !_isInputEnabled, // Habilita o deshabilita el campo
                    onChanged: (text) {
                      _updateFieldState(); // Actualiza el estado del botón
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.0),
            LockableButton(
              label: 'Guardar',
              isLoading: _submitting,
              isLocked: _isButtonLocked, // Usa isLocked en lugar de isEnabled
              onPressed: _updateField,
            ),
          ],
        ),
      ),
    );
  }
}
