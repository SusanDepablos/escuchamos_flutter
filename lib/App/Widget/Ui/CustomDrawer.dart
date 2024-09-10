import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Label.dart';

class CustomDrawer extends StatelessWidget {
  final String? name;
  final String? username;
  final int? followers;
  final int? following;
  final ImageProvider? imageProvider;
  final Future<void> Function()? onProfileTap;
  final Future<void> Function()? onContentModerationTap;
  final Future<void> Function()? onSettingsTap;
  final Future<void> Function()? onAboutTap;
  final Future<void> Function()? onFollowsTap;
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
    this.onFollowsTap,
    this.showContentModeration = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.whiteapp, // Color de fondo del Drawer
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.0), // Redondea solo la esquina superior derecha
            bottomRight: Radius.circular(16.0), // Redondea solo la esquina inferior derecha
          ),
          border: Border(
            right: BorderSide(
              width: 2, // Ancho del borde con gradiente
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppColors.whiteapp,
          padding: const EdgeInsets.fromLTRB(
            25,
            55.0,
            10.0,
            0.0,
          ),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto de perfil
              ProfileAvatar(
                avatarSize: 50.0,
                iconSize: 30.0,
                imageProvider: imageProvider,
                showBorder: false,
                onPressed: onProfileTap,
              ),
              const SizedBox(height: 10),
              // Texto
              Text(
                name ?? '...',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '@${username ?? '...'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.black,
                  fontStyle: FontStyle.italic,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              // Información de seguidores y siguiendo
              Row(
                children: [
                  Text(
                    '${following ?? '0'}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  LabelAction(
                    text: 'Siguiendo',
                    onPressed: () {},
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.inputDark,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 20), // Espacio entre "Siguiendo" y "Seguidores"
                  Text(
                    '${followers ?? '0'}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  LabelAction(
                    text: 'Seguidores',
                    onPressed: onFollowsTap,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.inputDark,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 1.0,
          margin: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          decoration: BoxDecoration(
            color: AppColors.inputLigth,
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.black),
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
          margin: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          decoration: BoxDecoration(
            color: AppColors.inputLigth,
            borderRadius: BorderRadius.circular(1.0),
          ),
        ),
        SizedBox(
          height: 60,
          child: ListTile(
            leading:
              const Icon(MaterialIcons.settings, color: AppColors.black, size: 24.0),
            title: const Text(
              'Configuración y privacidad',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.black),
            ),
            onTap: () async {
              if (onSettingsTap != null) {
                await onSettingsTap!(); // Usar '!' para indicar que 'onSettingsTap' no es null
              }
            },
            tileColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 9.0,
              horizontal: 25.0,
            ),
          ),
        ),
        SizedBox(
          height: 115,
          child: ListTile(
            leading: const Icon(MaterialIcons.info, color: AppColors.black, size: 24.0),
            title: const Text(
              'Acerca de',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onTap: () async {
              if (onAboutTap != null) {
                await onAboutTap!(); // Usar '!' para indicar que 'onAboutTap' no es null
              }
            },
            tileColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 7.0,
              horizontal: 25.0,
            ),
          ),
        ),
      ],
    );
  }
}
