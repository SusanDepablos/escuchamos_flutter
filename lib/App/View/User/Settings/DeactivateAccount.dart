import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';

class DeactivateAccount extends StatefulWidget {
  @override
  _DeactivateAccountState createState() => _DeactivateAccountState();
}

class _DeactivateAccountState extends State<DeactivateAccount> {
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
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              const Text(
                'Eliminar cuenta',
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
      body: SingleChildScrollView(
        // Scroll añadido
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título de la sección
              const Text(
                'Esta acción eliminará tu cuenta',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 16.0), // Espacio entre el título y el contenido
              // Contenido informativo
              const Text(
                'Estás por iniciar el proceso de eliminación de tu cuenta. Tu nombre visible, tu nombre de usuario y tu perfil ya no se podrán ver en EscuChamos.',
                style: TextStyle(fontSize: 16.0, color: AppColors.black),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                  height: 24.0), // Espacio antes del siguiente bloque de texto

              // Más información
              const Text(
                'Qué más debes saber',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8.0), // Espacio entre el título y el contenido

              const Text(
                'Antes de proceder, ten en cuenta que si eliminas tu cuenta de EscuChamos, no habrá forma de restaurarla. Si tu cuenta se eliminó por error o accidentalmente, no podrás recuperarla.\n\n'
                'Si solo deseas cambiar tu nombre de usuario, no es necesario que elimines tu cuenta; puedes modificarlo en tu configuración.\n\n'
                'Asegúrate de cambiar tu nombre de usuario o dirección de correo electrónico si deseas utilizarlos con otra cuenta de EscuChamos antes de proceder. Recuerda que una vez eliminada, no hay camino de vuelta.',
                style: TextStyle(fontSize: 16.0, color: AppColors.black),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 54.0), // Espacio antes del botón

              const Divider(color: AppColors.inputLigth, height: 40.0),
              GenericButton(
                label: 'Eliminar',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    'deactivate', // Nombre de la ruta definida en el archivo de rutas
                  );
                },
                isLoading:
                    false, // Cambia a true si necesitas mostrar un indicador de carga
                color: AppColors.errorRed, // Color personalizado, opcional
              ),
            ],
          ),
        ),
      ),
    );
  }
}
