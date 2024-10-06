import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/FullScreenImage.dart';
import 'dart:io';
import 'package:escuchamos_flutter/App/Widget/Dialog/ImagePickerBottomSheet.dart';

class CommentPopupUpdateWidget extends StatefulWidget {
  final String nameUser;
  final String? body;
  final String? mediaUrl;
  final String? profilePhotoUser;
  final String? error;
  final Function(String, String?)? onCommentUpdate;
  final bool isButtonDisabled;
  final VoidCallback? onCancel;

  CommentPopupUpdateWidget({
    Key? key,
    required this.nameUser,
    this.error,
    this.onCancel,
    this.body,
    this.onCommentUpdate,
    this.mediaUrl,
    this.profilePhotoUser,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.nameUser,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
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
                                  fontWeight: FontWeight.bold,
                                ),
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
                                  fontWeight: FontWeight.bold,
                                ),
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
                        avatarSize: 40.0,
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
