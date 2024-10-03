import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart';

class PopupPostWidget extends StatefulWidget {
  final String nameUser;
  final String username; // Agrega el campo para el nombre de usuario
  final String? body;
  final String? profilePhotoUser;
  final String? error;
  final Function(String)? onPostUpdate;
  final VoidCallback? onCancel;
  final bool isButtonDisabled;

  PopupPostWidget({
    Key? key,
    required this.nameUser,
    required this.username, // Inicializa el nombre de usuario
    this.error,
    this.body,
    this.onPostUpdate,
    this.profilePhotoUser,
    this.onCancel,
    required this.isButtonDisabled,
  }) : super(key: key);

  @override
  _PopupPostWidgetState createState() => _PopupPostWidgetState();
}

class _PopupPostWidgetState extends State<PopupPostWidget> {
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _bodyController = TextEditingController(text: widget.body);
  }

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Contenedor principal que agrupa la foto de perfil, el nombre y el cuerpo del post
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: AppColors.whiteapp,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fila para la foto de perfil y el nombre del usuario
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileAvatar(
                      imageProvider: widget.profilePhotoUser != null && widget.profilePhotoUser!.isNotEmpty
                          ? NetworkImage(widget.profilePhotoUser!)
                          : null,
                      avatarSize: 40.0,
                      showBorder: false,
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre del usuario
                        Text(
                          widget.nameUser,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        // Nombre de usuario en formato @tal
                        Text(
                          '@${widget.username}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                // Campo de texto para el cuerpo del post
                BodyTextField(
                  input: _bodyController,
                  error: widget.error,
                  minLines: 1,
                  maxLines: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: widget.onCancel,
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: widget.isButtonDisabled ? null : () async {
                        String body = _bodyController.text;
                        await widget.onPostUpdate?.call(body);
                      },
                      child: Text(
                        'Guardar',
                        style: TextStyle(
                          color: widget.isButtonDisabled ? AppColors.grey : AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}