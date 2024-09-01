import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  UserModel? _user;
  String? name;

  @override
  void initState() {
    super.initState();
    _callUser();
  }

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
                name ?? '...',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              Text(
                'Configuración',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500, // Negrita básica
                  color: AppColors.inputDark,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              leading: Icon(
                MaterialIcons.person, 
                color: AppColors.black,
                size: 30.0, // Ajusta este valor según el tamaño que desees
              ),
              title: Text(
                'Información de la cuenta',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              subtitle: Text(
                'Ver y actualizar los detalles de tu cuenta',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.inputDark,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'account-information');
              },
            ),
            ListTile(
              leading: Icon(
                MaterialIcons.lock, 
                color: AppColors.black,
                size: 30.0, // Ajusta este valor según el tamaño que desees
              ),
              title: Text(
                'Cambiar contraseña',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                'Actualiza tu contraseña de forma segura',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.inputDark,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'Base');
              },
            ),
            ListTile(
              leading: Icon(
                MaterialIcons.cancel, 
                color: AppColors.black,
                size: 30.0, // Ajusta este valor según el tamaño que desees
              ),
              title: Text(
                'Desactivar cuenta',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              subtitle: Text(
                'Desactiva tu cuenta temporalmente',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.inputDark,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'deactivate');
              },
            ),
          ],
        ),

      ),
    );
  }
}
