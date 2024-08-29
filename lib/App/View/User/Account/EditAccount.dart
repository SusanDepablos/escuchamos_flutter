import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditAccount extends StatefulWidget {
  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<EditAccount> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  UserModel? _user;
  String? username;
  String? phoneNumber;
  String? email;
  String? country;
  bool isLoading =
      true; // Agregamos esta variable para controlar el estado de carga

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
            username = '@${_user!.data.attributes.username}';
            phoneNumber = _user!.data.attributes.phoneNumber;
            email = _user!.data.attributes.email;
            country = _user?.data.relationships.country?.attributes.name;
            isLoading = false; // La carga ha finalizado
          });
        } else {
          setState(() {
            isLoading =
                false; // Aseguramos que la carga ha finalizado incluso en caso de error
          });
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
        setState(() {
          isLoading = false; // La carga ha finalizado en caso de excepción
        });
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
                'Información de la cuenta',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              Text(
                username ?? "...",
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
              title: Text(
                'Nombre de usuario',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              subtitle: Text(
                username ?? "...", 
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500, // Negrita básica
                  color: AppColors.inputDark,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'Base');
              },
            ),
            ListTile(
              title: Text(
                'Teléfono',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                isLoading ? "Cargando..." : (phoneNumber ?? "Añadir"),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500, // Negrita básica
                  color: AppColors.inputDark,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'Base');
              },
            ),
            ListTile(
              title: Text(
                'Correo electrónico',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              subtitle: Text(
                email ?? "...",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500, // Negrita básica
                  color: AppColors.inputDark,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'Base');
              },
            ),
            ListTile(
              title: Text(
                'País',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              subtitle: Text(
                isLoading ? "..." : (country ?? "Añadir"),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500, // Negrita básica
                  color: AppColors.inputDark,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'Base');
              },
            ),
          ],
        ),
      ),
    );
  }
}
