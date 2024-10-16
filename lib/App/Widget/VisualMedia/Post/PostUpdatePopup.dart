import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/MediaCarousel.dart'; // Asegúrate de que esta importación sea correcta

class PopupPostWidget extends StatefulWidget {
  final String username; // Agrega el campo para el nombre de usuario
  final String? body;
  final String? profilePhotoUser;
  final String? error;
  final Function(String)? onPostUpdate;
  final VoidCallback? onCancel;
  final bool isButtonDisabled;
  final bool isVerified;
  final List<String>? mediaUrls; // Nuevo parámetro

  PopupPostWidget({
    Key? key,
    required this.username, // Inicializa el nombre de usuario
    this.error,
    this.body,
    this.onPostUpdate,
    this.profilePhotoUser,
    this.onCancel,
    required this.isButtonDisabled,
    this.isVerified = false,
    this.mediaUrls, // Inicializa el nuevo parámetro
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
      child: SingleChildScrollView( // Agregado para permitir scroll
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
                        avatarSize: AppFond.avatarSize,
                        showBorder: false,
                      ),
                      const SizedBox(width: 10.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center, // Alinea el texto y el ícono al centro
                        children: [
                          Text(
                            widget.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppFond.username,
                            ),
                          ),
                          const SizedBox(width: 4), // Espacio entre el nombre y el ícono de verificación
                          if (widget.isVerified)
                            const Icon(
                              CupertinoIcons.checkmark_seal_fill,
                              size: AppFond.iconVerified,
                              color: AppColors.primaryBlue, // Cambia el color según prefieras
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  if (widget.mediaUrls != null && widget.mediaUrls!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: MediaCarousel(mediaUrls: widget.mediaUrls!),
                    ),
                  // Campo de texto para el cuerpo del post
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: BodyTextField(
                      input: _bodyController,
                      error: widget.error,
                      minLines: 1,
                      maxLines: 6,
                    ),
                  ),
                  // Mostrar los medios, si los hay
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: widget.onCancel,
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: AppFond.subtitle
                          ),
                          textScaleFactor: 1.0
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
                            fontSize: AppFond.subtitle
                          ),
                          textScaleFactor: 1.0
                        ),
                      ),
                    ],
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
