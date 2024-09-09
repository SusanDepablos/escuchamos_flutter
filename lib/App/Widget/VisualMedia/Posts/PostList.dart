import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Label.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/VideoPlayer.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/FullScreenImage.dart';

class PostWidget extends StatelessWidget {
  final String nameUser;
  final String usernameUser;
  final String? profilePhotoUser;
  final VoidCallback? onProfileTap;
  final DateTime createdAt;

  final String reactionsCount;
  final String commentsCount;
  final String sharesCount;

  final String? body;
  final String? mediaUrl;

  const PostWidget({
    Key? key,
    required this.nameUser,
    required this.usernameUser,
    this.profilePhotoUser,
    this.onProfileTap,
    required this.createdAt,
    this.reactionsCount = '120',
    this.commentsCount = '45',
    this.sharesCount = '30',
    this.body,
    this.mediaUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Definir tamaño fijo para la imagen y el video
    const double mediaHeight = 250.0;
    const double mediaWidth = double.infinity;

    return Container(
      margin: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 8.0,
        bottom: 8.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.greyLigth,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileAvatar(
                  imageProvider:  profilePhotoUser != null &&
                      profilePhotoUser!.isNotEmpty
                  ? NetworkImage(profilePhotoUser!)
                  : null,
                  avatarSize: 40.0,
                  showBorder: true,
                  onPressed: onProfileTap,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Separar el nombre de usuario en un Container
                      Row(
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 150), // Limitar el ancho del contenedor
                            child: Text(
                              nameUser,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis, // Agregar puntos suspensivos si es muy largo
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatDate(createdAt),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          const Icon(
                            Icons.more_vert,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      Text(
                        '@$usernameUser',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            if (mediaUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: GestureDetector(
                  onTap: () {
                    if (!mediaUrl!.endsWith('.mp4')) {
                      // Abre la imagen a pantalla completa usando FullScreenImage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(imageUrl: mediaUrl!),
                        ),
                      );
                    } 
                    // Para los videos no hacemos nada aquí, ya que no se quiere fullscreen
                  },
                  child: SizedBox(
                    height: mediaHeight,
                    width: mediaWidth,
                    child: mediaUrl!.endsWith('.mp4')
                        ? AspectRatio(
                            aspectRatio: 16 / 9, // Proporción adecuada para video
                            child: VideoPlayerWidget(videoUrl: mediaUrl!),
                          )
                        : Image.network(
                            mediaUrl!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
            if (body != null) ...[
              Text(
                body!,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16.0),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LabelAction(
                  text: reactionsCount,
                  icon: Icons.favorite,
                  onPressed: () {},
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                LabelAction(
                  text: commentsCount,
                  icon: Icons.chat_bubble,
                  onPressed: () {},
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                LabelAction(
                  text: sharesCount,
                  icon: Icons.repeat,
                  onPressed: () {},
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime createdAt) {
    return "${createdAt.day}-${createdAt.month}-${createdAt.year}";
  }
}
