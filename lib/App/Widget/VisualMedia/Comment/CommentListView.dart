import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/FullScreenImage.dart';
import 'package:audioplayers/audioplayers.dart';

class CommentWidget extends StatelessWidget {
  final String nameUser;
  final String usernameUser;
  final String? profilePhotoUser;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLikeTap;
  final bool reaction;
  final DateTime createdAt;

  final String reactionsCount;
  final String commentsCount;
  final String sharesCount;

  final String? body;
  final String? mediaUrl;
  final AudioPlayer _audioPlayer = AudioPlayer();  // Crea el AudioPlayer

  CommentWidget({
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

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('sounds/click.mp3')); // Ruta del archivo de sonido
  }

  @override
  Widget build(BuildContext context) {
    const double mediaHeight = 250.0;
    const double mediaWidth = double.infinity;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(
              left: 56.0,
              right: 16.0,
              top: 8.0,
              bottom: 8.0),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: AppColors.greyLigth, // Mantén este color si es el deseado
            borderRadius: BorderRadius.circular(25.0), // Ajuste a 25
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 10.0),
              if (mediaUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GestureDetector(
                    onTap: () {
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
              if (mediaUrl != null)
                const SizedBox(height: 10.0),
              if (body != null) ...[
                Text(
                  body!,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
              ],
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!reaction) {
                        _playSound();
                      }
                      if (onLikeTap != null) {
                        onLikeTap!(); // Ejecutar cualquier otra acción
                      }
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        reaction
                            ? Icons.favorite
                            : Icons.favorite_border,
                        key: ValueKey<bool>(reaction),
                        color: reaction ? Colors.red : Colors.grey,
                        size: 24,
                      ),
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
        Positioned(
          left: 8.0,
          top: 8.0,
          child: Container(
            width: 40.0,
            height: 40.0,
            child: ProfileAvatar(
              imageProvider: profilePhotoUser != null && profilePhotoUser!.isNotEmpty
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

}
