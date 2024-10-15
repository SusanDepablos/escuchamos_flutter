import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/MediaCarousel.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Post/RepostListView.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart';

  String _formatDate(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return difference.inSeconds == 1 ? "1 s" : "${difference.inSeconds} s";
    } else if (difference.inMinutes < 60) {
      return difference.inMinutes == 1 ? "1 min" : "${difference.inMinutes} min";
    } else if (difference.inHours < 24) {
      return difference.inHours == 1 ? "1 h" : "${difference.inHours} h";
    } else if (difference.inDays < 7) {
      return difference.inDays == 1 ? "1 d" : "${difference.inDays} d";
    } else if (difference.inDays < 30) {
      return "${createdAt.day} ${_getAbbreviatedMonthName(createdAt.month)}";
    } else {
      return "${createdAt.day} ${_getAbbreviatedMonthName(createdAt.month)} de ${createdAt.year}";
    }
  }

  String _getAbbreviatedMonthName(int month) {
    const monthNames = [
      "ene", "feb", "mar", "abr", "may", "jun",
      "jul", "ago", "sep", "oct", "nov", "dic"
    ];
    return monthNames[month - 1];
  }

class RepostCreateWidget extends StatefulWidget {
  final String username;
  final String? body;
  final String? profilePhotoUser;
  final Function(String)? onPostUpdate;
  final VoidCallback? onCancel;
  final bool isButtonDisabled;
  final bool isVerified;

  final String? bodyRepost;
  final String usernameUserRepost;
  final DateTime createdAtRepost;
  final String? profilePhotoUserRepost;
  final List<String>? mediaUrlsRepost;
  final VoidCallback? onPostTap;
  final VoidCallback? onProfileTapRepost;
  final bool isVerifiedRepost;

  final Widget bodyTextField;

  RepostCreateWidget({
    Key? key,
    required this.username,
    this.body,
    this.onPostUpdate,
    this.profilePhotoUser,
    this.onCancel,
    required this.isButtonDisabled,
    this.isVerified = false,

    this.bodyRepost,
    required this.usernameUserRepost,
    this.profilePhotoUserRepost,
    required this.createdAtRepost,
    this.mediaUrlsRepost,
    this.onPostTap,
    this.onProfileTapRepost,
    this.isVerifiedRepost = false,
    required this.bodyTextField, // Nuevo parámetro
  }) : super(key: key);

  @override
  _RepostCreateWidgetState createState() => _RepostCreateWidgetState();
}

class _RepostCreateWidgetState extends State<RepostCreateWidget> {

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
              color: AppColors.greyLigth,
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6, // Ajusta el ancho según sea necesario
                          child: Row(
                            children: [
                              // El nombre de usuario
                              Text(
                                widget.username, // Asegúrate de que widget.nameUser no sea null
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 4), // Espacio entre el nombre y el ícono de verificación
                              // Aquí va el ícono de verificación
                              if (widget.isVerified) // Asegúrate de definir isVerified
                                const Icon(
                                  CupertinoIcons.checkmark_seal_fill,
                                  size: 16,
                                  color: AppColors.primaryBlue, // Cambia el color según prefieras
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                widget.bodyTextField,
                // Campo de texto para el cuerpo del post
                PostWidgetInternal(
                  usernameUser: widget.usernameUserRepost,
                  profilePhotoUser: widget.profilePhotoUserRepost,
                  createdAt: widget.createdAtRepost, // Ajusta esta fecha según sea necesario
                  mediaUrls: widget.mediaUrlsRepost, // Puedes pasar las URLs de medios aquí
                  body: widget.bodyRepost, // Cuerpo del repost
                  onTap: () {
                    // Acción a realizar al tocar el widget
                  },
                  onProfileTap: () {
                    // Acción a realizar al tocar el perfil
                  },
                  isVerified: widget.isVerifiedRepost,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
