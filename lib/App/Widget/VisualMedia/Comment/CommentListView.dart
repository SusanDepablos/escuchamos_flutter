import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/FullScreenImage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/ShowConfirmationDialog.dart';

class CommentWidget extends StatelessWidget {
  final String nameUser;
  final String usernameUser;
  final String? profilePhotoUser;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLikeTap;
  final VoidCallback? onNumberLikeTap;
  final VoidCallback? onResponseTap;
  final bool reaction;
  final DateTime createdAt;
  final String reactionsCount;
  final String repliesCount;
  final bool isHidden;
  final String? body;
  final String? mediaUrl;

  final int authorId;
  final int currentUserId;
  final VoidCallback onEditTap;
  final VoidCallback? onDeleteTap;
  final VoidCallback onReportTap;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Crea el AudioPlayer

  CommentWidget({
    Key? key,
    required this.nameUser,
    required this.reaction,
    required this.usernameUser,
    required this.createdAt,
    this.profilePhotoUser,
    this.isHidden = false,
    this.onLikeTap,
    this.onNumberLikeTap,
    this.onResponseTap,
    this.onProfileTap,

    required this.authorId,
    required this.currentUserId,
    this.onDeleteTap,
    required this.onEditTap,
    required this.onReportTap,
    
    this.reactionsCount = '0',
    this.repliesCount = '0',
    this.body,
    this.mediaUrl,
  }) : super(key: key);

  Future<void> _playSound() async {
    await _audioPlayer
        .play(AssetSource('sounds/click.mp3')); // Ruta del archivo de sonido
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} s'; // Segundos
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min'; // Minutos
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h'; // Horas
    } else if (difference.inDays < 7) {
      return '${difference.inDays} d'; // Días (1 d, 2 d, ..., 7 d)
    } else {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks sem'; // Semanas
    }
  }

  void _onDeleteItem(BuildContext context) {
    showConfirmationDialog(
      context,
      title: 'Confirmar eliminación',
      content:
          '¿Estás seguro de que quieres eliminarlo? Esta acción no se puede deshacer.',
      onConfirmTap: () {
        if (onDeleteTap != null) {
          onDeleteTap!();
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
                  leading:
                      const Icon(MaterialIcons.edit, color: AppColors.black),
                  title: const Text('Editar',
                      style: TextStyle(color: AppColors.black)),
                  onTap: () {
                    // Lógica para editar la publicación
                    Navigator.pop(context); // Cerrar el modal
                    onEditTap();
                  },
                ),
                ListTile(
                  leading: const Icon(MaterialIcons.delete,
                      color: AppColors.errorRed),
                  title: const Text('Eliminar',
                      style: TextStyle(color: AppColors.errorRed)),
                  onTap: () {
                    Navigator.pop(context); // Cerrar el modal primero
                    _onDeleteItem(
                        context); // Mostrar el diálogo de confirmación
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(MaterialIcons.report,
                      color: AppColors.errorRed),
                  title: const Text('Reportar',
                      style: TextStyle(color: AppColors.errorRed)),
                  onTap: () {
                    // Lógica para reportar la publicación
                    Navigator.pop(context); // Cerrar el modal
                    onReportTap();
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double mediaHeight = 250.0;
    const double mediaWidth = double.infinity;

    return GestureDetector(
        onLongPress: () => _showOptionsModal(context),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 56.0,
                right: 16.0,
                top: 8.0,
                bottom: 8.0,
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: AppColors.greyLigth,
                borderRadius: BorderRadius.circular(25.0),
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
                      // Aquí añadimos la fecha formateada
                      Text(
                        _formatDate(createdAt),
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 14,
                        ),
                      ),
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
                  if (mediaUrl != null) const SizedBox(height: 10.0),
                  if (body != null && body != '') ...[
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
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: Icon(
                            reaction
                                ? MaterialIcons.favorite
                                : MaterialIcons.favoriteBorder,
                            key: ValueKey<bool>(reaction),
                            color:
                                reaction ? AppColors.errorRed : AppColors.grey,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      // Número de reacciones
                      GestureDetector(
                        onTap: onNumberLikeTap,
                        child: Text(
                          reactionsCount,
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 30.0),
                      // Texto "Responder"
                      if (!isHidden) ...[
                        GestureDetector(
                          onTap: onResponseTap,
                          child: const Text(
                            'Responder',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        GestureDetector(
                          onTap: onResponseTap,
                          child: Text(
                            repliesCount,
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ]
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
        ));
  }
}
