import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class ProfileAvatar extends StatelessWidget {
  final VoidCallback? onPressed;
  final double avatarSize;
  final double iconSize;

  ProfileAvatar({
    this.onPressed,
    this.avatarSize = 40.0,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = CircleAvatar(
      radius: avatarSize / 2,
      backgroundColor: AppColors.inputLigth,
      child: Icon(
        Icons.person,
        color: AppColors.inputDark,
        size: iconSize,
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
        onTap: () {
          // No hacer nada si onPressed es null
        },
      );
    }
  }
}
