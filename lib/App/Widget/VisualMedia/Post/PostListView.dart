import 'package:escuchamos_flutter/App/Widget/Dialog/ShowConfirmationDialog.dart';
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
  final VoidCallback? onDeleteTap;
  final bool reaction;
  final DateTime createdAt;

  final String reactionsCount;
  final String commentsCount;
  final String sharesCount;

  final String? body;
  final List<String>? mediaUrls;
  final int authorId;
  final int currentUserId; 
  final VoidCallback onEditTap; 
  final VoidCallback? onRepostTap;
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
    required this.authorId,
    required this.currentUserId,
    this.onDeleteTap,
    required this.onEditTap, 
    this. onRepostTap, 
  }) : super(key: key);

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('sounds/click.mp3'));
  }

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

  void _onDeleteItem(BuildContext context) {
    showConfirmationDialog(
      context,
      title: 'Confirmar eliminación',
      content: '¿Estás seguro de que quieres eliminarlo? Esta acción no se puede deshacer.',
      onConfirmTap: () {
        if (onDeleteTap != null) {
          onDeleteTap!(); // Llama a la función de eliminación
        }
      },
    );
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
              if (currentUserId == authorId) ...[
                ListTile(
                  leading: const Icon(MaterialIcons.edit, color: AppColors.black),
                  title: const Text('Editar', style: TextStyle(color: AppColors.black)),
                  onTap: () {
                    // Lógica para editar la publicación
                    Navigator.pop(context); // Cerrar el modal
                    onEditTap();
                  },
                ),
                ListTile(
                  leading: const Icon(MaterialIcons.delete, color: AppColors.errorRed),
                  title: const Text('Eliminar', style: TextStyle(color: AppColors.errorRed)),
                  onTap: () {
                    Navigator.pop(context); // Cerrar el modal primero
                    _onDeleteItem(context); // Mostrar el diálogo de confirmación
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(MaterialIcons.report, color: AppColors.errorRed),
                  title: const Text('Reportar', style: TextStyle(color: AppColors.errorRed)),
                  onTap: () {
                    // Lógica para reportar la publicación
                    Navigator.pop(context); // Cerrar el modal
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showShareModal(BuildContext context) {
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
                leading: const Icon(MaterialIcons.repeat),
                title: const Text('Compartir'),
                onTap: () {
                  // Lógica para repostear
                  Navigator.pop(context); 
                },
              ),
              ListTile(
                leading: const Icon(MaterialIcons.editNote),
                title: const Text('Repostear'),
                onTap: () {
                  Navigator.pop(context); // Cerrar el modal
                  onRepostTap!();
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
              if (body != null && body != '') ...[
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
                        GestureDetector(
                          onTap: () => _showShareModal(context), // Mostrar modal de compartir
                          child: const Icon(
                            MaterialIcons.repeat,
                            color: AppColors.grey,
                          ),
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
}
