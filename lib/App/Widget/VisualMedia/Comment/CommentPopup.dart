import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/FullScreenImage.dart';
import 'dart:io';
import 'package:escuchamos_flutter/App/Widget/Dialog/ImagePickerBottomSheet.dart';

void CommentPopup(
  BuildContext context, {
  required String nameUser,
  String? body,
  String? mediaUrl,
  String? profilePhotoUser,
  VoidCallback? onProfileTap,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: PopupCommentWidget(
          nameUser: nameUser,
          body: body,
          mediaUrl: mediaUrl,
          profilePhotoUser: profilePhotoUser,
          onProfileTap: onProfileTap,
        ),
      );
    },
  );
}

class PopupCommentWidget extends StatefulWidget {
  final String nameUser;
  final String? body;
  final String? mediaUrl;
  final String? profilePhotoUser;
  final VoidCallback? onProfileTap;

  PopupCommentWidget({
    Key? key,
    required this.nameUser,
    this.body,
    this.mediaUrl,
    this.profilePhotoUser,
    this.onProfileTap,
  }) : super(key: key);

  @override
  _PopupCommentWidgetState createState() => _PopupCommentWidgetState();
}

class _PopupCommentWidgetState extends State<PopupCommentWidget> {
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
                    left: 56.0,
                    right: 10.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: AppColors.whiteapp,
                    borderRadius: BorderRadius.circular(25.0),
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
                        // Mostrar la imagen seleccionada
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImage(
                                      imageUrl: _selectedImage!.path),
                                ),
                              );
                            },
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                      if (_selectedImage != null) const SizedBox(height: 10.0),
                      TextField(
                        controller: _bodyController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "...",
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(
                          height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap:
                                _showImagePickerDialog,
                            child: const Text(
                              'Añadir',
                              style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                            },
                            child: const Text(
                              'Responder',
                              style: TextStyle(
                                color: AppColors.black,
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
                  left: 8.0,
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
                      onPressed: widget.onProfileTap,
                    ),
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