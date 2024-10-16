import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Command/CountryCommand.dart';
import 'package:escuchamos_flutter/Api/Service/CountryService.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/Api/Model/CountryModels.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Select.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'dart:convert';

class PhoneUpdate extends StatefulWidget {
  @override
  _PhoneUpdateState createState() => _PhoneUpdateState();
}

class _PhoneUpdateState extends State<PhoneUpdate> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  List<Map<String, String?>> countryData = [];
  UserModel? _user;
  bool _submitting = false;
  String? name;
  String? phone;
  String? _selected;
  bool _isInputEnabled = false; // Estado del NumericInput
  bool _isButtonLocked = true; // Estado del LockableButton

  static const int _minDigits = 8; // Cantidad mínima de dígitos

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
            phone = _user!.data.attributes.phoneNumber;
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

  Future<void> _callCountries() async {
    final countryCommand = CountryCommandIndex(CountryIndex());

    try {
      var response = await countryCommand.execute();

      if (mounted) {
        if (response is CountriesModel) {
          setState(() {
            countryData = response.data.map((datum) {
              return {
                'isoCode': datum.attributes.iso,
                'dialingCode': datum.attributes.dialingCode,
              };
            }).toList();

            // Extraer solo los códigos ISO para el dropdown
            if (_selected != null &&
                !countryData.any((data) => data['isoCode'] == _selected)) {
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

  void _updateFieldState() {
    final phoneNumberLength = input['phone_number']!.text.length;

    setState(() {
      _isInputEnabled = _selected != null && _selected!.isNotEmpty;
      _isButtonLocked = !(_isInputEnabled && phoneNumberLength >= _minDigits);
    });
  }

  Future<void> _updateField() async {
    setState(() {
      _submitting = true;
    });

    try {
      final selectedCountry = countryData.firstWhere(
        (data) => data['dialingCode']! + data['isoCode']! == _selected,
        orElse: () => {'dialingCode': ''},
      );

      final dialingCode = selectedCountry['dialingCode'];

      final body = jsonEncode({
        'phone_number': '$dialingCode ${input['phone_number']!.text}',
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

  @override
  void initState() {
    super.initState();
    _callUser();
    _callCountries();
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cambiar número telefónico',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: AppFond.title,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  textScaleFactor: 1.0,
                ),
                const SizedBox(height: 1.0),
                if (phone != null && phone!.isNotEmpty)
                  Text(
                    'Número actual: $phone',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: AppFond.text,
                      color: AppColors.black,
                      fontStyle: FontStyle.italic,
                    ),
                    textScaleFactor: 1.0,
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: SelectWithFlags(
                    selectedValue: _selected,
                    itemsMap: countryData,
                    hintText: '+0',
                    textStyle: const TextStyle(
                      color: AppColors.black,
                      fontSize: AppFond.text,
                      fontWeight: FontWeight.w800,
                    ),
                    dropdownColor: AppColors.whiteapp,
                    iconSize: 0,
                    onChanged: (value) {
                      setState(() {
                        _selected = value;
                        _updateFieldState(); // Actualiza el estado del campo y del botón
                      });
                    },
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: NumericInput(
                    text: 'Número telefónico',
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
            const SizedBox(height: 20.0),
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
