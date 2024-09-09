import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class UserListView extends StatelessWidget {
  final String nameUser;
  final String usernameUser;
  final String? profilePhotoUser;

  const UserListView({
    Key? key,
    required this.nameUser,
    required this.usernameUser,
    this.profilePhotoUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  : null, // Si no hay imagen, se pasará null para que ProfileAvatar use su icono predeterminado
              avatarSize: 40.0,
              showBorder: true,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: Text(
                      nameUser,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '@$usernameUser',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
