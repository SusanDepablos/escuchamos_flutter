import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Input.dart';
import 'package:escuchamos_flutter/App/Widget/Button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/App/Widget/Logo.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class EditProfile extends StatefulWidget {

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<EditProfile> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  UserModel? _user;
  bool _submitting = false;

  final input = {
    'name': TextEditingController(),
    'biography': TextEditingController(),
    'birthdate': TextEditingController(),
  };

    final _borderColors = {
    'name': AppColors.inputBasic,
    'biography': AppColors.inputBasic,
    'birthdate': AppColors.inputBasic
  };

  final Map<String, String?> _errorMessages = {
    'name': null,
    'biography': null,
    'birthdate': null, 
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
              input['name']!.text = _user!.data.attributes.name;
              input['biography']!.text = _user!.data.attributes.biography ?? '';
              input['birthdate']!.text = _user!.data.attributes.birthdate.toString().substring(0, 10);
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

  @override
  void initState() {
    super.initState();
    _callUser();
  }

    Future<void> _updateUser() async {
    setState(() {
      _submitting = true;
    });

    try {
      var response = await UserCommandUpdate(UserUpdate()).execute(
        input['name']!.text,
        input['biography']!.text,
        input['birthdate']!.text
      );

      if (response is ValidationResponse) {
        
        if (response.key['name'] != null) {
          setState(() {
            _borderColors['name'] = AppColors.inputDark;
            _errorMessages['name'] = response.message('name');
          });
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _borderColors['name'] = AppColors.inputBasic;
              _errorMessages['name'] = null;
            });
          });
        }

        if (response.key['birthdate'] != null) {
          setState(() {
            _borderColors['birthdate'] = AppColors.inputDark;
            _errorMessages['birthdate'] = response.message('birthdate');
          });
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _borderColors['birthdate'] = AppColors.inputBasic;
              _errorMessages['birthdate'] = null;
            });
          });
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: response is SuccessResponse
                ? 'Success'
                : response is InternalServerError
                    ? 'Error'
                    : 'Error de Conexión',
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
      setState(() {
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteapp,
      appBar: AppBar(
      backgroundColor: AppColors.whiteapp,
        automaticallyImplyLeading: false,
      title: LogoBanner(), // Aquí se inserta el LogoBanner en el AppBar
        centerTitle: true, // Para centrar el LogoBanner en el AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            GenericInput(
              text: 'Nombre y Apellido',
              input: input['name']!,
              border: _borderColors['name']!,
              error: _errorMessages['name'],
            ),
            SizedBox(height: 8.0),
            GenericInput(
              text: 'Biografía',
              input: input['biography']!,
              border: _borderColors['biography']!,
              error: _errorMessages['biography'],
            ),
            SizedBox(height: 8.0),
            DateInput(
              text: 'Fecha de Nacimiento',
              input: input['birthdate']!,
              border: _borderColors['birthdate']!,
              error: _errorMessages['birthdate'],
            ),
            SizedBox(height: 32.0),
            GenericButton(
              label: 'Actualizar',
              onPressed: _updateUser,
              isLoading: _submitting,
            ),
          ],
        ),
      ),
    );
  }
}
