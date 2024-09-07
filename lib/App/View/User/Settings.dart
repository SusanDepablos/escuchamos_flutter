import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart';
import 'package:escuchamos_flutter/Api/Service/AuthService.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  UserModel? _user;
  String? name;
  bool _submitting = false;

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
          builder: (context) => PopupWindow(
            title: 'Correcto',
            message: response.message,
          ),
        );
        // Elimina el token y otros datos del almacenamiento seguro
        await _storage.delete(key: 'token');
        await _storage.delete(key: 'session_key');
        await _storage.delete(key: 'user');
        await _storage.delete(key: 'groups');

        // Redirige al usuario a la pantalla de login
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
              const Text(
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
              leading: const Icon(
                MaterialIcons.person, 
                color: AppColors.black,
                size: 25.0, // Ajusta este valor según el tamaño que desees
              ),
              title: const Text(
                'Información de la cuenta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              subtitle: const Text(
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
              leading: const Icon(
                MaterialIcons.lock, 
                color: AppColors.black,
                size: 25.0, // Ajusta este valor según el tamaño que desees
              ),
              title: const Text(
                'Cambiar contraseña',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              subtitle: const Text(
                'Actualiza tu contraseña de forma segura',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'user-change-password');
              },
            ),
            ListTile(
              leading: const Icon(
                MaterialIcons.cancel, 
                color: AppColors.black,
                size: 25.0, // Ajusta este valor según el tamaño que desees
              ),
              title: const Text(
                'Desactivar cuenta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              subtitle: const Text(
                'Desactiva tu cuenta temporalmente',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'deactivate-account');
              },
            ),
            ListTile(
              leading: const Icon(
                MaterialIcons.logout,
                color: AppColors.errorRed,
                size: 25.0, // Ajusta este valor según el tamaño que desees
              ),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.errorRed,
                ),
              ),
              onTap: _submitting ? null : () async {
                await _logout(context);
              },
            ),
          ],
        ),

      ),
    );
  }
}
