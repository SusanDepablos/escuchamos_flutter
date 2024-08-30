import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class ProfileAvatar extends StatelessWidget {
  final VoidCallback? onPressed;
  final double avatarSize;
  final double iconSize;
  final ImageProvider? imageProvider; // Agregar este parámetro

  ProfileAvatar({
    this.onPressed,
    this.avatarSize = 40.0,
    this.iconSize = 24.0,
    this.imageProvider, // Inicializar el parámetro
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 3.0,
        ),
      ),
      child: CircleAvatar(
        radius: avatarSize / 2,
        backgroundColor: AppColors.inputLigth,
        backgroundImage: imageProvider, // Usar imagen proporcionada
        child: imageProvider == null
            ? Icon(
                Icons.person,
                color: AppColors.inputDark,
                size: iconSize,
              )
            : null,
      ),
    );

    if (onPressed != null) {
      return IconButton(
        icon: avatar,
        onPressed: onPressed,
      );
    } else {
      return GestureDetector(
        child: avatar,
        onTap: () {},
      );
    }
  }
}
