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
                name ?? '...',
                style: const TextStyle(
                  fontSize: AppFond.title,
                  fontWeight:
                      FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              Text(
                'Configuración',
                style: TextStyle(
                  fontSize: AppFond.subtitle,
                  color: AppColors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            SizedBox(height: 16),
            ListTile(
              leading: Icon(
                MaterialIcons.person, 
                color: AppColors.black,
                size: 25.0, // Ajusta este valor según el tamaño que desees
              ),
              title: Text(
                'Información de la cuenta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              subtitle: Text(
                'Ver y actualizar los detalles de tu cuenta',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.black,
                  fontStyle: FontStyle.italic,
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
                size: 25.0, // Ajusta este valor según el tamaño que desees
              ),
              title: Text(
                'Cambiar contraseña',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              subtitle: Text(
                'Actualiza tu contraseña de forma segura',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.black,
                  fontStyle: FontStyle.italic,
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
                size: 25.0, // Ajusta este valor según el tamaño que desees
              ),
              title: Text(
                'Desactivar cuenta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              subtitle: Text(
                'Desactiva tu cuenta temporalmente',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.black,
                  fontStyle: FontStyle.italic,
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
