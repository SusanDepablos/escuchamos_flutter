import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';

class AccountInformation extends StatefulWidget {
  @override
  _AccountInformationState createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  UserModel? _user;
  String? username;
  String? phoneNumber;
  String? email;
  String? country;
  String? name;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _callUser();
  }

  void reloadView() {
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
            name = _user?.data.attributes.name;
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
        setState(() {
          isLoading = false; // La carga ha finalizado en caso de excepción
        });
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
              ),
              const Text(
                'Información de la cuenta',
                style: TextStyle(
                  fontSize: AppFond.subtitle,
                  color: AppColors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      body: Center(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            ListTile(
              title: const Text(
                'Nombre de usuario',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              subtitle: Text(
                username ?? "...", 
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onTap: () async {
                // Navega a la página 'edit-account' y espera su resultado
                final result = await Navigator.pushNamed(
                  context,
                  'edit-account',
                  arguments: {
                    'text': 'Nombre de usuario',
                    'label': 'Cambiar nombre de usuario',
                    'textChanged': false,
                    'field': 'username'
                  },
                );

                reloadView();
              },
            ),
            ListTile(
              title: const Text(
                'Teléfono',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              subtitle: Text(
                isLoading ? "..." : (phoneNumber ?? "Añadir"),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  'phone-update',
                );

                reloadView();
              },
            ),
            ListTile(
              title: const Text(
                'Correo electrónico',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              subtitle: Text(
                email ?? "...",
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  'email-update',
                );

                reloadView();
              },
            ),
            ListTile(
              title: const Text(
                'País',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              subtitle: Text(
                isLoading ? "..." : (country ?? "Añadir"),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onTap: () async{
                final result = await Navigator.pushNamed(
                  context,
                  'country-update',
                );

                reloadView();
              },
            ),
          ],
        ),
      ),
    );
  }
}
