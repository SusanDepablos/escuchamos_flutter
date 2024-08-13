import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart';
import 'package:escuchamos_flutter/Api/Service/AuthService.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart';

class Home extends StatelessWidget {
  final String token;
  final String user;
  final List<dynamic> groups;

  Home({
    required this.token,
    required this.user,
    required this.groups,
  });

  Future<void> _logout(BuildContext context) async {
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
        Navigator.pushNamedAndRemoveUntil(
          context,
          'login', // Reemplaza con la ruta a tu pantalla de inicio de sesión
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        automaticallyImplyLeading: false, // Esto evita que aparezca la flecha de retroceso
      ),
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
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Color de fondo rojo para el botón de logout
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
  }
}
