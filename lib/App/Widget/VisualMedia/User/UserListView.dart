import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class UserListView extends StatelessWidget {
  final String nameUser;
  final String usernameUser;
  final String? profilePhotoUser;
  final VoidCallback? onTap;
  final VoidCallback? onPhotoUserTap;
  final bool isVerified;

  const UserListView({
    Key? key,
    required this.nameUser,
    required this.usernameUser,
    this.profilePhotoUser,
    this.onPhotoUserTap,
    this.onTap,
    this.isVerified = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Ejecuta la función cuando se toca el widget
      child: Container(
        margin: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 8.0,
          bottom: 8.0,
        ),
        decoration: BoxDecoration(
          color: AppColors.greyLigth,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileAvatar(
                imageProvider: profilePhotoUser != null &&
                        profilePhotoUser!.isNotEmpty
                    ? NetworkImage(profilePhotoUser!)
                    : null,
                onPressed: onPhotoUserTap,
                avatarSize: AppFond.avatarSize,
                showBorder: true,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 150),
                          child: Flexible(
                            child: Text(
                              usernameUser,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppFond.username,
                              ),
                              textScaleFactor: 1.0,
                              overflow: TextOverflow.ellipsis, // Recortar con puntos suspensivos si es demasiado largo
                              maxLines: 1, // Limitar a una sola línea
                            ),
                          ),
                        ),
                        const SizedBox(width: 4), // Espaciador entre el nombre y el ícono
                        if (isVerified)
                          const Icon(
                            CupertinoIcons.checkmark_seal_fill,// Reemplaza con el ícono que desees
                            color: AppColors.primaryBlue, // Cambia el color según sea necesario
                            size: 16, // Tamaño del ícono
                          ),
                      ],
                    ),
                    Text(
                      '$nameUser',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: AppFond.name,
                      ),
                      textScaleFactor: 1.0
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
