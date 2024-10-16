import 'package:escuchamos_flutter/App/Widget/Dialog/ShowConfirmationDialog.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/MediaCarousel.dart';

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

class RepostWidget extends StatelessWidget {
  final String usernameUser;
  final String? profilePhotoUser;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLikeTap;
  final VoidCallback? onIndexLikeTap;
  final VoidCallback? onIndexCommentTap;
  final VoidCallback? onDeleteTap;
  final bool reaction;
  final DateTime createdAt;
  final bool isVerified;
  final int reactionsCount;
  final int commentsCount;
  final int totalSharesCount;
  final String? body;
  final int authorId;
  final int currentUserId;
  final VoidCallback onEditTap;
  final AudioPlayer _audioPlayer = AudioPlayer();

  //Repost
  final String? bodyRepost;
  final String usernameUserRepost;
  final DateTime createdAtRepost;
  final String? profilePhotoUserRepost;
  final List<String>? mediaUrlsRepost;
  final VoidCallback onPostTap;
  final VoidCallback? onProfileTapRepost;
  final VoidCallback? onRepostTap;
  final VoidCallback onReportTap;
  final VoidCallback onShareTap;
  final bool isVerifiedRepost;

  RepostWidget({
    Key? key,
    required this.reaction,
    required this.usernameUser,
    required this.createdAt,
    this.isVerified = false,
    this.onIndexCommentTap,
    this.profilePhotoUser,
    this.onIndexLikeTap,
    this.onLikeTap,
    this.onProfileTap,
    this.reactionsCount = 0,
    this.commentsCount = 0,
    this.totalSharesCount = 0,
    this.body,
    required this.authorId,
    required this.currentUserId,
    this.onDeleteTap,
    required this.onEditTap,

    //Repost
    this.bodyRepost,
    required this.usernameUserRepost,
    this.profilePhotoUserRepost,
    required this.createdAtRepost,
    this.mediaUrlsRepost,
    required this.onPostTap,
    this.onProfileTapRepost,
    this.onRepostTap,
    required this.onReportTap,
    required this.onShareTap,
    this.isVerifiedRepost = false,
  }) : super(key: key);

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('sounds/click.mp3'));
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


  void _showShareModal(BuildContext context) {
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
                ListTile(
                  leading: const Icon(
                    CupertinoIcons.arrow_2_squarepath,
                    size: 22,
                  ),
                  title: const Text('Compartir', 
                  style: TextStyle(color: AppColors.black, fontSize: AppFond.subtitle),)
                  ,
                  onTap: () {
                    Navigator.pop(context); 
                    onShareTap();
                  },
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.pencil_ellipsis_rectangle, size: 22),
                  title: const Text('Repostear',
                  style: TextStyle(color: AppColors.black, fontSize: AppFond.subtitle),),
                  onTap: () {
                    Navigator.pop(context); // Cerrar el modal
                    onRepostTap!();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
                children: [
                  ProfileAvatar(
                    imageProvider: profilePhotoUser != null && profilePhotoUser!.isNotEmpty
                        ? NetworkImage(profilePhotoUser!)
                        : null,
                    avatarSize: AppFond.avatarSize,
                    showBorder: true,
                    onPressed: onProfileTap,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye espacio entre el nombre y el icono
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 230),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacio entre los elementos
                                children: [
                                  // Nombre de usuario
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            usernameUser,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: AppFond.username,
                                            ),
                                            overflow: TextOverflow.ellipsis, // Recortar con puntos suspensivos si es demasiado largo
                                            maxLines: 1, // Limitar a una sola línea
                                          ),
                                        ),
                                        const SizedBox(width: 4), // Espacio entre el nombre y el ícono de verificación
                                        if (isVerified)
                                          const Icon(
                                            CupertinoIcons.checkmark_seal_fill,
                                            size: AppFond.iconVerified,
                                            color: AppColors.primaryBlue, // Cambia el color según prefieras
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Tres puntos
                                  GestureDetector(
                                    onTap: () {
                                      _showOptionsModal(context);
                                    },
                                    child: const Icon(
                                      CupertinoIcons.ellipsis,
                                      color: AppColors.grey, // Color de los tres puntos
                                      size: AppFond.iconMore,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Fecha
                            Text(
                              _formatDate(createdAt),
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontSize: AppFond.date,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (body != null && body != '')
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    body!,
                    style: const TextStyle(fontSize: AppFond.body),
                ),
              ),
              // Agregar el PostWidget interno
              PostWidgetInternal(
                usernameUser: usernameUserRepost,
                profilePhotoUser: profilePhotoUserRepost,
                createdAt: createdAtRepost,
                mediaUrls: mediaUrlsRepost,
                body: bodyRepost,
                onTap: () {
                  onPostTap();
                },
                onProfileTap: onProfileTapRepost,
                isVerified: isVerifiedRepost,
              ),
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
                              reaction ? CupertinoIcons.heart_fill // Si reaccionado, icono lleno
                              : CupertinoIcons.heart,
                              key: ValueKey<bool>(reaction),
                              color: reaction ? AppColors.errorRed : AppColors.grey,
                              size: AppFond.iconHeart,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: onIndexLikeTap,
                          child: Text(
                            reactionsCount.toString(),
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: AppFond.count,
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
                            CupertinoIcons.bubble_left,
                            color: AppColors.grey,
                            size: AppFond.iconChat,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: onIndexCommentTap,
                          child: Text(
                            commentsCount.toString(),
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: AppFond.count,
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
                            CupertinoIcons.arrow_2_squarepath,
                            color: AppColors.grey,
                            size: AppFond.iconShare,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          totalSharesCount.toString(),
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: AppFond.count,
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

// PostWidget interno simplificado
class PostWidgetInternal extends StatelessWidget {
  final String usernameUser;
  final String? profilePhotoUser;
  final DateTime createdAt;
  final String? body;
  final List<String>? mediaUrls;
  final VoidCallback onTap;
  final VoidCallback? onProfileTap;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final bool isVerified;

  const PostWidgetInternal({
    Key? key,
    required this.usernameUser,
    this.profilePhotoUser,
    required this.createdAt,
    this.body,
    this.mediaUrls,
    required this.onTap,
    this.onProfileTap,
    this.color,
    this.margin,
    this.isVerified = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.only(
          left: 0,
          right: 0,
          top: 16.0,
          bottom: 16.0,
        ),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: color ?? AppColors.whiteapp,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.whiteapp,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfileAvatar(
                  imageProvider: profilePhotoUser != null && profilePhotoUser!.isNotEmpty
                      ? NetworkImage(profilePhotoUser!)
                      : null,
                  avatarSize: AppFond.avatarSizeSmall,
                  iconSize: AppFond.iconSizeSmall,
                  onPressed: onProfileTap,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: MediaQuery(
                              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      usernameUser,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppFond.username,
                                      ),
                                      overflow: TextOverflow.ellipsis, // Recortar con puntos suspensivos si es demasiado largo
                                      maxLines: 1, // Limitar a una sola línea
                                    ),
                                  ),
                                  const SizedBox(width: 4), // Espacio entre el nombre y el ícono de verificación
                                  if (isVerified)
                                    const Icon(
                                      CupertinoIcons.checkmark_seal_fill,
                                      size: AppFond.iconVerified,
                                      color: AppColors.primaryBlue, // Cambia el color según prefieras
                                    ),
                                ],
                              ),
                            ),
                          ),
                          MediaQuery(
                            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                            child: Text(
                              _formatDate(createdAt),
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontSize: AppFond.date,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (mediaUrls != null && mediaUrls!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: MediaCarousel(mediaUrls: mediaUrls!),
              ),
            if (body != null && body != '')
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: Text(
                    body!,
                    style: const TextStyle(fontSize: AppFond.body),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
