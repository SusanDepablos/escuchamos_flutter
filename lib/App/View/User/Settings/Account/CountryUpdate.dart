import 'package:flutter/material.dart';
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
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'dart:convert';

class CountryUpdate extends StatefulWidget {
  @override
  _CountryUpdateState createState() => _CountryUpdateState();
}

class _CountryUpdateState extends State<CountryUpdate> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  List<Map<String, String?>> countryData = [];
  UserModel? _user;
  bool _submitting = false;
  String? name;
  String? country;
  String? _selected;

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
            country = _user?.data.relationships.country?.attributes.name;
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
                'name': datum.attributes.name,
                'id': datum.id.toString(),
              };
            }).toList();

            // Extraer solo los códigos ISO para el dropdown
            if (_selected != null &&
                !countryData.any((data) => data['id'] == _selected)) {
              _selected = null;
            }
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

  Future<void> _updateCountry() async {
    setState(() {
      _submitting = true;
    });

    try {
      final body = jsonEncode({
        'country_id':
            _selected, // o cualquier otro campo que utilices para el ID del país
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
      await showDialog(
        context: context,
        builder: (context) => PopupWindow(
          title: 'Error',
          message: 'Espera un poco, pronto lo solucionaremos.',
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
                const Text(
                  'Cambiar país',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 1.0),
                if (country != null && country!.isNotEmpty)
                  Text(
                    'País actual: ${country ?? '...'}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  )
              ],
            ),
            const SizedBox(height: 16.0),
            SelectCountryWithFlags(
              selectedValue: _selected,
              itemsMap: countryData,
              hintText: 'Seleccione un país',
              textStyle: const TextStyle(
                color: AppColors.black,
                fontSize: 16,
              ),
              dropdownColor: AppColors.whiteapp,
              onChanged: (value) {
                setState(() {
                  _selected = value;
                  // Aquí puedes almacenar el ID o ISO seleccionado para la actualización
                });
              },
            ),
            const SizedBox(height: 20.0),
            GenericButton(
              label: 'Actualizar',
              onPressed: _updateCountry,
              isLoading: _submitting,
            ),
          ],
        ),
      ),
    );
  }
}
