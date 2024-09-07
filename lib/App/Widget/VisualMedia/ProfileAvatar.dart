import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';

class ProfileAvatar extends StatelessWidget {
  final VoidCallback? onPressed;
  final double avatarSize;
  final double iconSize;
  final ImageProvider? imageProvider;
  final bool isEditing;
  final bool showBorder;

  ProfileAvatar({
    this.onPressed,
    this.avatarSize = 40.0,
    this.iconSize = 24.0,
    this.imageProvider,
    this.isEditing = false,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: AppColors.whiteapp,
                width: 3.0,
              )
            : null,
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
                  color: AppColors.whiteapp,
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

    // Usar IconButton si onPressed no es nulo
    if (onPressed != null) {
      return IconButton(
        icon: avatar,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      );
    } else {
      // Usar GestureDetector si onPressed es nulo
      return GestureDetector(
        child: avatar,
        onTap: () {},
      );
    }
  }
}
