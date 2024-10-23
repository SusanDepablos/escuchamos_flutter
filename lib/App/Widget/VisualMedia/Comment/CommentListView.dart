import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/FullScreenImage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/ShowConfirmationDialog.dart';

class CommentWidget extends StatelessWidget {
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
  final bool isVerified;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Crea el AudioPlayer

  CommentWidget({
    Key? key,
    required this.usernameUser,
    required this.reaction,
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
    this.isVerified = false,
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
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
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
                    leading: const Icon(CupertinoIcons.pencil, color: AppColors.black),
                    title: const Text(
                      'Editar',
                      style: TextStyle(color: AppColors.black, fontSize: AppFond.subtitle),
                    ),
                    onTap: () {
                      Navigator.pop(context); // Cerrar el modal
                      onEditTap();
                    },
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.delete_solid, color: AppColors.errorRed),
                    title: const Text(
                      'Eliminar',
                      style: TextStyle(color: AppColors.errorRed, fontSize: AppFond.subtitle),
                    ),
                    onTap: () {
                      Navigator.pop(context); // Cerrar el modal primero
                      _onDeleteItem(context); // Mostrar el diálogo de confirmación
                    },
                  ),
                ] else ...[
                  ListTile(
                    leading: const Icon(MaterialIcons.report, color: AppColors.errorRed),
                    title: const Text(
                      'Reportar',
                      style: TextStyle(color: AppColors.errorRed, fontSize: AppFond.subtitle),
                    ),
                    onTap: () {
                      Navigator.pop(context); // Cerrar el modal
                      onReportTap();
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
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
            bottom: 8.0,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: AppColors.greyLigth,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center, // Alineación centrada verticalmente
                children: [
                  MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text(
                      usernameUser,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFond.username,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (isVerified)
                    const Icon(
                      CupertinoIcons.checkmark_seal_fill,
                      size: AppFond.iconVerified,
                      color: AppColors.primaryBlue,
                    ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _showOptionsModal(context);
                    },
                    child: const Icon(
                      CupertinoIcons.ellipsis,
                      color: AppColors.grey,
                      size: AppFond.iconMore,
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
                          builder: (context) => FullScreenImage(imageUrl: mediaUrl!),
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
                MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: Text(
                    body!,
                    style: const TextStyle(
                      fontSize: AppFond.body,
                    ),
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
                        onLikeTap!();
                      }
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        reaction ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                        key: ValueKey<bool>(reaction),
                        color: reaction ? AppColors.errorRed : AppColors.grey,
                        size: AppFond.iconHeartComment,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: onNumberLikeTap,
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text(
                        reactionsCount,
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: AppFond.countComment,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  if (!isHidden) ...[
                    GestureDetector(
                      onTap: onResponseTap,
                      child: const Text(
                        'Responder',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: AppFond.response,
                        ),
                        textScaleFactor: 1.0
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: onResponseTap,
                      child: MediaQuery(
                        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                        child: Text(
                          repliesCount,
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: AppFond.countComment,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text(
                      _formatDate(createdAt),
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: AppFond.countComment,
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
              imageProvider: profilePhotoUser != null && profilePhotoUser!.isNotEmpty
                  ? NetworkImage(profilePhotoUser!)
                  : null,
              avatarSize: AppFond.avatarSize,
              showBorder: true,
              onPressed: onProfileTap,
            ),
          ),
        ),
      ],
    );
  }

}
