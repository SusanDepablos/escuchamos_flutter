import 'package:escuchamos_flutter/App/Widget/Icons.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/ProfileAvatar.dart';

class CustomDrawer extends StatelessWidget {
  final String? name;
  final String? username;
  final int followers;
  final int following;
  final ImageProvider? imageProvider;
  final Future<void> Function()? onProfileTap;
  final Future<void> Function()? onContentModerationTap;
  final Future<void> Function()? onSettingsTap;
  final Future<void> Function()? onAboutTap;
  final bool showContentModeration; 
  CustomDrawer({
    this.name,
    this.username,
    required this.followers,
    required this.following,
    this.imageProvider,
    this.onProfileTap,
    this.onContentModerationTap,
    this.onSettingsTap,
    this.onAboutTap,
    this.showContentModeration = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteapp, // Color de fondo del Drawer
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.0), // Redondea solo la esquina superior derecha
            bottomRight: Radius.circular(16.0), // Redondea solo la esquina inferior derecha
          ),
          border: Border(
            right: BorderSide(
              width: 1.5, // Ancho del borde con gradiente
              color: Colors.transparent, // Usamos color transparente aquí
            ),
          ),
          gradient: LinearGradient(
            colors: [
              AppColors.primaryBlue,
              AppColors.deepPurple,
              AppColors.errorRed
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Drawer(
          child: Container(
            color: AppColors.whiteapp, // Color de fondo del contenido del Drawer
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                _buildBody(context),
                Expanded(child: Container()),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          color: AppColors.whiteapp,
          padding: EdgeInsets.fromLTRB(
            25,
            55.0,
            10.0,
            0.0,
          ),
          height: 200,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileAvatar(
                    avatarSize: 50.0,
                    iconSize: 30.0,
                    imageProvider: imageProvider,
                    showBorder: false,
                    onPressed: onProfileTap,
                  ),
                  SizedBox(height: 10),
                  Text(
                    name ?? '...',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    '@$username',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '$following',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        'Siguiendo',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.inputDark,
                        ),
                      ),
                      SizedBox(width: 35),
                      Text(
                        '$followers',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        'Seguidores',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.inputDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 16),
            ],
          ),
        ),
        Container(
          height: 1.0,
          margin: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(1.0),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    Widget _buildListTile({
      required IconData icon,
      required String title,
      required Future<void> Function()? onTap,
    }) {
      return ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        leading: Icon(icon, color: AppColors.black, size: 24.0),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        onTap: () async {
          if (onTap != null) {
            await onTap();
          }
        },
        tileColor: Colors.transparent,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListTile(
            icon: MaterialIcons.person,
            title: 'Perfil',
            onTap: onProfileTap,
          ),
          if (showContentModeration) _buildListTile(
            icon: MaterialIcons.description,
            title: 'Moderación de contenido',
            onTap: onContentModerationTap,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          height: 1.0,
          margin: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(1.0),
          ),
        ),
        SizedBox(
          height: 60,
          child: ListTile(
            leading:
                Icon(MaterialIcons.settings, color: AppColors.black, size: 24.0),
            title: Text(
              'Configuración y privacidad',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onTap: () async {
              if (onSettingsTap != null) {
                await onSettingsTap!(); // Usar '!' para indicar que 'onSettingsTap' no es null
              }
            },
            tileColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              vertical: 9.0,
              horizontal: 25.0,
            ),
          ),
        ),
        SizedBox(
          height: 115,
          child: ListTile(
            leading: Icon(MaterialIcons.info, color: AppColors.black, size: 24.0),
            title: Text(
              'Acerca de',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onTap: () async {
              if (onAboutTap != null) {
                await onAboutTap!(); // Usar '!' para indicar que 'onAboutTap' no es null
              }
            },
            tileColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              vertical: 7.0,
              horizontal: 25.0,
            ),
          ),
        ),
      ],
    );
  }
}
