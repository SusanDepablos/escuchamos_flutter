import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/ShowConfirmationDialog.dart';

class UserOptionsModal extends StatefulWidget {
  final VoidCallback? onDeleteTap;
  final VoidCallback? showChangeRoleDialog; // Eliminar el guion bajo

  UserOptionsModal({
    this.onDeleteTap,
    this.showChangeRoleDialog, // Cambiado aquí también
  });
  @override
  _UserOptionsModalState createState() => _UserOptionsModalState();
}


class _UserOptionsModalState extends State<UserOptionsModal> {

  @override
  Widget build(BuildContext context) {
    return  MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
        decoration: const BoxDecoration(
          color: AppColors.whiteapp,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.pencil, color: AppColors.black),
              title: const Text('Cambio de rol',
                  style: TextStyle(color: AppColors.black, fontSize: AppFond.subtitle)),
              onTap: () {
                Navigator.pop(context);
                widget.showChangeRoleDialog?.call(); // Mostrar el diálogo de cambio de rol
              },
            ),
          ],
        ),
      )
    );
  }
}

