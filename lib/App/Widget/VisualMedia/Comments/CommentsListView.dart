import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/FullScreenImage.dart';

class CommentWidget extends StatelessWidget {
  final String nameUser;
  final String usernameUser;
  final String? profilePhotoUser;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLikeTap;
  final Color reaction;
  final DateTime createdAt;

  final String reactionsCount;
  final String commentsCount;
  final String sharesCount;

  final String? body;
  final String? mediaUrl;

  const CommentWidget({
    Key? key,
    required this.nameUser,
    required this.reaction,
    required this.usernameUser,
    required this.createdAt,
    this.profilePhotoUser,
    this.onLikeTap,
    this.onProfileTap,
    this.reactionsCount = '120',
    this.commentsCount = '45',
    this.sharesCount = '30',
    this.body,
    this.mediaUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double mediaHeight = 250.0;
    const double mediaWidth = double.infinity;
    return Stack(
      children: [
        // Contenedor blanco con toda la información del comentario
        Container(
          margin: const EdgeInsets.only(
              left: 56.0,
              right: 16.0,
              top: 8.0,
              bottom:
                  8.0), // Ajustar margen izquierdo para dejar espacio para el avatar
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre del usuario como título
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      nameUser,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                ],
              ),
              const SizedBox(height: 4.0),
              if (mediaUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GestureDetector(
                    onTap: () {
                      // Abre la imagen a pantalla completa usando FullScreenImage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullScreenImage(imageUrl: mediaUrl!),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: mediaHeight,
                      width: mediaWidth,
                      child: Image.network(
                        mediaUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
              if (body != null) ...[
                Text(
                  body!,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
              Row(
                children: [
                  GestureDetector(
                    onTap: onLikeTap,
                    child: Icon(
                      Icons.favorite,
                      color: reaction,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    child: Text(
                      reactionsCount,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    '$commentsCount Comments',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                ],
              ),
            ],
          ),
        ),
        // Contenedor invisible para el avatar con espacio adicional
        Positioned(
          left: 8.0, // Ajustar posición horizontal del contenedor invisible
          top: 8.0, // Ajustar posición vertical del contenedor invisible
          child: Container(
            width: 40.0, // Ancho del contenedor para el avatar
            height: 40.0, // Alto del contenedor para el avatar
            child: ProfileAvatar(
              imageProvider:
                  profilePhotoUser != null && profilePhotoUser!.isNotEmpty
                      ? NetworkImage(profilePhotoUser!)
                      : null,
              avatarSize: 40.0,
              showBorder: true,
              onPressed: onProfileTap,
            ),
          ),
        ),
      ],
    );
  }

  // Eliminado el método _formatDate ya que la fecha ya no se usa
}
