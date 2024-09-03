import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Icons.dart';

class SettingsMenu extends StatelessWidget {
  final Future<void> Function() onEditProfile;
  final Future<void> Function() onLogout;

  SettingsMenu({
    required this.onEditProfile,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String result) async {
        if (result == 'edit') {
          await onEditProfile(); // Ejecuta la función de navegación al editar perfil
        } else if (result == 'logout') {
          await onLogout(); // Ejecuta la función de cerrar sesión
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(MaterialIcons.edit, color: AppColors.black), // Puedes ajustar el color del ícono
              SizedBox(width: 8),
              Text(
                'Editar perfil',
                style: TextStyle(
                  fontSize: 16, // Tamaño de fuente
                  fontWeight: FontWeight.w500, // Peso de la fuente
                  color: AppColors.black, // Color del texto
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(MaterialIcons.logout, color: AppColors.errorRed), // Puedes ajustar el color del ícono
              SizedBox(width: 8),
              Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontSize: 16, // Tamaño de fuente
                  fontWeight: FontWeight.w500, // Peso de la fuente
                  color: AppColors.errorRed, // Color del texto
                ),
              ),
            ],
          ),
        ),
      ],
      color: AppColors.whiteapp, // Fondo blanco para el menú
    );
  }
}
