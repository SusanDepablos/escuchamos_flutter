import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Icons.dart';

class ProfileAvatar extends StatelessWidget {
  final VoidCallback? onPressed;
  final double avatarSize;
  final double iconSize;
  final ImageProvider? imageProvider;
  final bool isEditing; // Parámetro para indicar si se está editando
  final bool showBorder; // Nuevo parámetro para mostrar u ocultar el borde

  ProfileAvatar({
    this.onPressed,
    this.avatarSize = 40.0,
    this.iconSize = 24.0,
    this.imageProvider,
    this.isEditing = false, // Inicializar el parámetro
    this.showBorder = true, // Inicializar el parámetro
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: Colors.white,
                width: 3.0,
              )
            : null, // Mostrar u ocultar el borde
      ),
      child: CircleAvatar(
        radius: avatarSize / 2,
        backgroundColor: AppColors.inputLigth,
        backgroundImage: imageProvider,
        child: Stack(
          children: [
            if (imageProvider == null && !isEditing)
              Center(
                child: Icon(
                  MaterialIcons.person,
                  color: AppColors.inputDark,
                  size: iconSize,
                ),
              ),
            if (isEditing)
              Center(
                child: Icon(
                  MaterialIcons.addphoto,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
          ],
        ),
      ),
    );

    // Aplica la opacidad solo si isEditing es true y hay una imagen
    if (isEditing && imageProvider != null) {
      avatar = Opacity(
        opacity: 0.6,
        child: avatar,
      );
    }

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
