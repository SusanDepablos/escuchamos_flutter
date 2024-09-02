import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart';
import 'package:escuchamos_flutter/Api/Service/AuthService.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Label.dart'; 
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:convert';

class Home extends StatelessWidget {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> _logout(BuildContext context) async {
    final token = await _storage.read(key: 'token') ?? '';

    final userCommandLogout = UserCommandLogout(UserLogout());

    try {
      // Ejecutar el comando de cierre de sesión
      final response = await userCommandLogout.execute(token);

      if (response is SuccessResponse) {
        await showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Success',
            message: response.message,
          ),
        );
        // Elimina el token y otros datos del almacenamiento seguro
        await _storage.delete(key: 'token');
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
    }
  }

  Future<Map<String, dynamic>> _getData() async {
    final token = await _storage.read(key: 'token') ?? '';
    final user = await _storage.read(key: 'user') ?? '';
    final groupsString = await _storage.read(key: 'groups') ?? '[]';
    final groups = (groupsString.isNotEmpty) ? List<dynamic>.from(json.decode(groupsString)) : [];

    return {
      'token': token,
      'user': user,
      'groups': groups,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final data = snapshot.data!;
        final token = data['token'] as String;
        final user = data['user'] as String;
        final groups = data['groups'] as List<dynamic>;

        return Scaffold(
          backgroundColor: AppColors.whiteapp,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Token: $token', style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text('User: $user', style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text('Groups: ${groups.join(', ')}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8.0),
                BasicLabel(
                  name: 'Perfil',
                  color: AppColors.primaryBlue,
                  onTap: () {
                    Navigator.pushNamed(
                        context, 'profile');
                  },
                ),
                SizedBox(height: 8.0),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => _logout(context),
                  child: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

