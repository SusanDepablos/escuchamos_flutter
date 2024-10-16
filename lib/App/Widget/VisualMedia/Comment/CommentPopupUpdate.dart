import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/FullScreenImage.dart';

class CommentPopupUpdateWidget extends StatefulWidget {
  final String username;
  final String? body;
  final String? mediaUrl;
  final String? profilePhotoUser;
  final String? error;
  final Function(String, String?)? onCommentUpdate;
  final bool isButtonDisabled;
  final VoidCallback? onCancel;
  final bool isVerified;

  CommentPopupUpdateWidget({
    Key? key,
    required this.username,
    this.error,
    this.onCancel,
    this.body,
    this.onCommentUpdate,
    this.mediaUrl,
    this.profilePhotoUser,
    this.isVerified = false,
    required this.isButtonDisabled,
  }) : super(key: key);

  @override
  _CommentPopupUpdateWidgetState createState() => _CommentPopupUpdateWidgetState();
}

class _CommentPopupUpdateWidgetState extends State<CommentPopupUpdateWidget> {
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
    return IntrinsicHeight(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView( // Agregado para habilitar el scroll
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 50.0,
                      right: 0,
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: AppColors.whiteapp,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppFond.username,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor: 1.0
                            ),
                            // Aquí va el ícono de verificación
                            if (widget.isVerified) // Asegúrate de definir isVerified
                              const SizedBox(width: 4.0),
                            if (widget.isVerified) // Asegúrate de definir isVerified
                              const Icon(
                                CupertinoIcons.checkmark_seal_fill,
                                size: 16,
                                color: AppColors.primaryBlue, // Cambia el color según prefieras
                              ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        if (widget.mediaUrl != null) ...[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImage(imageUrl: widget.mediaUrl!),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: 300, // Ancho de la imagen
                              height: 250, // Alto de la imagen
                              child: Image.network(
                                widget.mediaUrl!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        ],
                        BodyTextField(
                          input: _bodyController,
                          error: widget.error,
                          minLines: 1,
                          maxLines: 6,
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: widget.onCancel,
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: AppFond.subtitle,
                                ),
                                textScaleFactor: 1.0
                              ),
                            ),
                            TextButton(
                              onPressed: widget.isButtonDisabled ? null : () async {
                                String body = _bodyController.text;
                                await widget.onCommentUpdate?.call(body, widget.mediaUrl);
                              },
                              child: Text(
                                'Comentar',
                                style: TextStyle(
                                  color: widget.isButtonDisabled ? AppColors.grey : AppColors.black,
                                  fontSize: AppFond.subtitle,
                                ),
                                textScaleFactor: 1.0
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 8.0,
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      child: ProfileAvatar(
                        imageProvider: widget.profilePhotoUser != null &&
                                widget.profilePhotoUser!.isNotEmpty
                            ? NetworkImage(widget.profilePhotoUser!)
                            : null,
                        avatarSize: AppFond.avatarSize,
                        showBorder: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
