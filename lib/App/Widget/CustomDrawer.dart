import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/ProfileAvatar.dart';

class CustomDrawer extends StatelessWidget {
  final String? name;
  final String? username;
  final int followers;
  final int following;
  final ImageProvider? imageProvider;

  CustomDrawer({
    this.name,
    this.username,
    required this.followers,
    required this.following,
    this.imageProvider, // Inicializa el parámetro
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6, // Ajusta el ancho a un 60% de la pantalla
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(), // Sección del encabezado
            _buildBody(context), // Sección del cuerpo
            Expanded(child: Container()), // Espacio flexible para empujar el pie hacia abajo
            _buildFooter(context), // Sección del pie
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          color: AppColors.whiteapp,
          padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0), // Aumenta el padding superior
          height: 176.0, // Mantén la altura en 176.0
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: ProfileAvatar(
                      avatarSize: 60.0, // Tamaño del CircleAvatar
                      iconSize: 30.0,
                      imageProvider: imageProvider, // Pasa el ImageProvider aquí
                    ),
                  ),
                  SizedBox(height: 1), // Espacio entre el CircleAvatar y el nombre
                  Text(
                    name ?? '...', // Usa el nombre proporcionado
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 1), // Espacio ajustado entre el nombre y el correo electrónico
                  Text(
                    '@$username', // Usa el username proporcionado
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600, // Negrita básica
                      color: AppColors.inputDark,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 10), // Espacio entre el correo electrónico y los nuevos textos
                  Row(
                    children: [
                      Text(
                        '$following', // Usa el valor de seguidos proporcionado
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        'Siguiendo', // Texto fijo
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.inputDark,
                        ),
                      ),
                      SizedBox(width: 26),
                      Text(
                        '$followers', // Usa el valor de seguidores proporcionado
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        'Seguidores', // Texto fijo
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.inputDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 16), // Espacio horizontal entre el Column y el borde derecho del Container
            ],
          ),
        ),
        Container(
          height: 1.0, // Altura de la línea fina
          margin: EdgeInsets.symmetric(horizontal: 20.0), // Ajusta el margen horizontal
          decoration: BoxDecoration(
            color: Colors.grey[300], // Color de la línea fina (ajusta según el diseño)
            borderRadius: BorderRadius.circular(1.0), // Radio pequeño para redondear los extremos
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListTile(
            icon: Icons.person,
            title: 'Perfil',
            onTap: () {
              //Navigator.pushNamed(context, 'profile');
            },
          ),
          _buildListTile(
            icon: Icons.description,
            title: 'Moderación de contenido',
            onTap: () {
              //Navigator.pushNamed(context, 'content-moderation');
            },
          ),
          // Agrega otras opciones aquí si es necesario
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        leading: Icon(icon, color: AppColors.primaryBlue, size: 24.0),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        _buildListTile(
          icon: Icons.settings, // Icono para Configuración
          title: 'Configuración',
          onTap: () {
            Navigator.pushNamed(context, 'settings');
          },
        ),
        _buildListTile(
          icon: Icons.info, // Icono para Acerca de
          title: 'Acerca de',
          onTap: () {
            Navigator.pushNamed(context, 'about');
          },
        ),
      ],
    );
  }
}
