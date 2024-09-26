import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/MediaCarousel.dart';
import 'package:audioplayers/audioplayers.dart';

class PostWidget extends StatelessWidget {
  final String nameUser;
  final String usernameUser;
  final String? profilePhotoUser;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLikeTap;
  final VoidCallback? onIndexLikeTap;
  final VoidCallback? onIndexCommentTap;
  final bool reaction;
  final DateTime createdAt;

  final String reactionsCount;
  final String commentsCount;
  final String sharesCount;

  final String? body;
  final List<String>? mediaUrls;
  final AudioPlayer _audioPlayer = AudioPlayer();

  PostWidget({
    Key? key,
    required this.nameUser,
    required this.reaction,
    required this.usernameUser,
    required this.createdAt,
    this.onIndexCommentTap,
    this.profilePhotoUser,
    this.onIndexLikeTap,
    this.onLikeTap,
    this.onProfileTap,
    this.reactionsCount = '120',
    this.commentsCount = '45',
    this.sharesCount = '30',
    this.body,
    this.mediaUrls,
  }) : super(key: key);

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('sounds/click.mp3'));
  }

  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteapp,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(MaterialIcons.edit),
                title: const Text('Editar'),
                onTap: () {
                  // Lógica para editar la publicación
                  Navigator.pop(context); // Cerrar el modal
                },
              ),
              ListTile(
                leading: const Icon(MaterialIcons.delete, color: AppColors.errorRed),
                title: const Text('Eliminar', style: TextStyle(color: AppColors.errorRed)),
                onTap: () {
                  // Lógica para eliminar la publicación
                  Navigator.pop(context); // Cerrar el modal
                },
              ),
              ListTile(
                leading: const Icon(MaterialIcons.report),
                title: const Text('Reportar',),
                onTap: () {
                  // Lógica para reportar la publicación
                  Navigator.pop(context); // Cerrar el modal
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showOptionsModal(context), // Mostrar modal al mantener presionado
      child: Container(
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
                    imageProvider: profilePhotoUser != null && profilePhotoUser!.isNotEmpty
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
                        Row(
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 140),
                              child: Text(
                                nameUser,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _formatDate(createdAt),
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '@$usernameUser',
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              if (mediaUrls != null && mediaUrls!.isNotEmpty)
                MediaCarousel(mediaUrls: mediaUrls!),
              if (mediaUrls != null && mediaUrls!.isNotEmpty)
                const SizedBox(height: 16.0),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!reaction) {
                              _playSound();
                            }
                            if (onLikeTap != null) {
                              onLikeTap!();
                            }
                          },
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return ScaleTransition(scale: animation, child: child);
                            },
                            child: Icon(
                              reaction ? MaterialIcons.favorite // Si reaccionado, icono lleno
                              : MaterialIcons.favoriteBorder,
                              key: ValueKey<bool>(reaction),
                              color: reaction ? AppColors.errorRed : AppColors.grey,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: onIndexLikeTap,
                          child: Text(
                            reactionsCount,
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: onIndexCommentTap,
                          child: const Icon(
                            MaterialIcons.comment,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: onIndexCommentTap,
                          child: Text(
                            commentsCount,
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          MaterialIcons.repeat,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 15),
                        Text(
                          sharesCount,
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime createdAt) {
    return "${createdAt.day}-${createdAt.month}-${createdAt.year}";
  }
}
