import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:io';
import 'package:escuchamos_flutter/App/Widget/Dialog/ImagePickerBottomSheet.dart';

class CommentPopupCreateWidget extends StatefulWidget {
  final String nameUser;
  final String? body;
  final String? mediaUrl;
  final String? profilePhotoUser;
  final String? error;
  final Function(String, String?)? onCommentCreate;
  final bool isButtonDisabled;
  final VoidCallback? onCancel;


  CommentPopupCreateWidget({
    Key? key,
    required this.nameUser,
    this.error,
    this.onCancel,
    this.body,
    this.onCommentCreate,
    this.mediaUrl,
    this.profilePhotoUser,
    required this.isButtonDisabled,
  }) : super(key: key);

  @override
  _CommentPopupCreateWidgetState createState() => _CommentPopupCreateWidgetState();
}

class _CommentPopupCreateWidgetState extends State<CommentPopupCreateWidget> {
  late TextEditingController _bodyController;
  File? _selectedImage;

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

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ImagePickerBottomSheet(
          onImagePicked: (File image) {
            setState(() {
              _selectedImage = image;
            });
          },
          onDeletePhoto: () {
            setState(() {
              _selectedImage = null;
            });
          },
          hasPhoto: _selectedImage != null,
        );
      },
    );
  }
@override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Expanded(
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
                      if (_selectedImage != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
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
                            onPressed: _showImagePickerDialog,
                            child: const Text(
                              'Añadir',
                              style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: widget.isButtonDisabled
                                ? null
                                : () async {
                                    String body = _bodyController.text;
                                    await widget.onCommentCreate
                                        ?.call(body, _selectedImage?.path);
                                  },
                            child: Text(
                              'Comentar',
                              style: TextStyle(
                                color: widget.isButtonDisabled
                                    ? AppColors.grey
                                    : AppColors.black,
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
                Positioned(
                  right: 16.0, // Ajusta este valor según sea necesario
                  top: 12.5,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close, // Icono de 'X'
                      color: AppColors.grey, // Color rojo
                    ),
                    onPressed: widget.onCancel, // Usa el parámetro pasado
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
