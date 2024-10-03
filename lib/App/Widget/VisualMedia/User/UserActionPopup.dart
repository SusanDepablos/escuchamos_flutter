import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/ShowConfirmationDialog.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Select.dart'; 

class UserOptionsModal extends StatefulWidget {
  final VoidCallback? onDeleteTap;
  final String hintText;
  final String title;
  final List<Map<String, String>> roles;

  UserOptionsModal({
    this.onDeleteTap,
    required this.hintText,
    required this.title,
    required this.roles,
  });

  @override
  _UserOptionsModalState createState() => _UserOptionsModalState();
}

class _UserOptionsModalState extends State<UserOptionsModal> {
  void _onDeleteItem(BuildContext context) {
    showConfirmationDialog(
      context,
      title: 'Confirmar eliminación',
      content:
          '¿Estás seguro de que quieres eliminarlo? Esta acción no se puede deshacer.',
      onConfirmTap: () {
        widget.onDeleteTap?.call();
      },
    );
  }

  void _showChangeRoleDialog(BuildContext context) {
    String? selectedRole;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: AppFond.title,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
            ),
          ),
          content: SingleChildScrollView( // Agregar este widget
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SelectBasic(
                  hintText: widget.hintText,
                  selectedValue: selectedRole,
                  items: widget.roles,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar diálogo
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                        color: AppColors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    if (selectedRole != null) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(
                        color: AppColors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.whiteapp,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(MaterialIcons.edit, color: AppColors.black),
            title: const Text('Cambio de rol',
                style: TextStyle(color: AppColors.black)),
            onTap: () {
              Navigator.pop(context);
              _showChangeRoleDialog(
                  context); // Mostrar el diálogo de cambio de rol
            },
          ),
          ListTile(
            leading:
                const Icon(MaterialIcons.delete, color: AppColors.errorRed),
            title: const Text('Eliminar',
                style: TextStyle(color: AppColors.errorRed)),
            onTap: () {
              _onDeleteItem(context);
            },
          ),
        ],
      ),
    );
  }
}

