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
  final Future<void> Function()? onAdminUserTap;
  final Future<void> Function()? onSettingsTap;
  final Future<void> Function()? onAboutTap;
  final Future<void> Function()? onFollowersTap;
  final Future<void> Function()? onFollowedTap;
  final bool showContentModeration; 
  final bool showAdminUser;
  final bool isVerified;

  CustomDrawer({
    this.name,
    this.username,
    required this.followers,
    required this.following,
    this.imageProvider,
    this.onProfileTap,
    this.showAdminUser = false,
    this.onContentModerationTap,
    this.onAdminUserTap,
    this.onSettingsTap,
    this.onAboutTap,
    this.onFollowersTap,
    this.onFollowedTap,
    this.showContentModeration = false,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.86,
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
          padding: const EdgeInsets.fromLTRB(16, 65.0, 16.0, 0.0),
          height: 235,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileAvatar(
                avatarSize: 50.0,
                iconSize: 30.0,
                imageProvider: imageProvider,
                showBorder: false,
                onPressed: onProfileTap,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    username ?? '...',
                    textScaleFactor: 1.0,
                    style: const TextStyle(
                      fontSize: AppFond.title,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 4),
                  if (isVerified)
                    const Icon(
                      CupertinoIcons.checkmark_seal_fill,
                      color: AppColors.primaryBlue,
                      size: AppFond.iconVerified,
                    ),
                ],
              ),
              Text(
                '${name ?? '...'}',
                textScaleFactor: 1.0,
                style: const TextStyle(
                  fontSize: AppFond.subtitle,
                  color: AppColors.black,
                  fontStyle: FontStyle.italic,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    '${followers ?? '0'}',
                    textScaleFactor: 1.0,
                    style: const TextStyle(
                      fontSize: AppFond.subtitle,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  LabelAction(
                    text: 'Seguidores',
                    onPressed: onFollowersTap,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 25),
                  Text(
                    '${following ?? '0'}',
                    textScaleFactor: 1.0,
                    style: const TextStyle(
                      fontSize: AppFond.subtitle,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  LabelAction(
                    text: 'Seguidos',
                    onPressed: onFollowedTap,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 1.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        leading: Icon(icon, color: AppColors.black, size: 24.0),
        title: Text(
          title,
          textScaleFactor: 1.0,
          style: const TextStyle(fontSize: AppFond.title, fontWeight: FontWeight.w500, color: AppColors.black),
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
      padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListTile(
            icon: CupertinoIcons.person_fill,
            title: 'Perfil',
            onTap: onProfileTap,
          ),
          if (showContentModeration)
            _buildListTile(
              icon: CupertinoIcons.doc_chart_fill,
              title: 'Moderación de contenido',
              onTap: onContentModerationTap,
            ),
          if (showAdminUser)
            _buildListTile(
              icon: CupertinoIcons.group_solid,
              title: 'Administrar Usuarios',
              onTap: onAdminUserTap,
            ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: AppColors.inputLigth,
            borderRadius: BorderRadius.circular(1.0),
          ),
        ),
        SizedBox(
          height: 70,
          child: ListTile(
            leading: const Icon(CupertinoIcons.gear_alt_fill, color: AppColors.black, size: 20.0),
            title: const Text(
              'Configuración y privacidad',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: AppFond.label, fontWeight: FontWeight.w500, color: AppColors.black),
            ),
            onTap: () async {
              if (onSettingsTap != null) {
                await onSettingsTap!();
              }
            },
            tileColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 25.0),
          ),
        ),
        SizedBox(
          height: 85,
          child: ListTile(
            leading: const Icon(CupertinoIcons.exclamationmark_circle_fill, color: AppColors.black, size: 20.0),
            title: const Text(
              'Acerca de',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: AppFond.label, fontWeight: FontWeight.w500),
            ),
            onTap: () async {
              if (onAboutTap != null) {
                await onAboutTap!();
              }
            },
            tileColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 25.0),
          ),
        ),
      ],
    );
  }

}
