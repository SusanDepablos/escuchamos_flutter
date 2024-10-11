import 'package:escuchamos_flutter/App/Widget/VisualMedia/FullScreenImage.dart';
import 'package:flutter/material.dart';
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

class RepostSimpleWidget extends StatelessWidget {
  final String nameUser;
  final String usernameUser;
  final String? profilePhotoUser;
  final DateTime createdAt;
  final String? body;

  //Repost
  final String? bodyRepost;
  final String nameUserRepost;
  final String usernameUserRepost;
  final DateTime createdAtRepost;
  final String? profilePhotoUserRepost;
  final List<String>? mediaUrlsRepost;
  final VoidCallback onRepostTap;
  final VoidCallback? onPostTap;
  final VoidCallback? onProfileTap;

  RepostSimpleWidget({
    Key? key,
    required this.nameUser,
    required this.usernameUser,
    required this.createdAt,
    this.profilePhotoUser,
    this.body,

    //Repost
    this.bodyRepost,
    required this.nameUserRepost,
    required this.usernameUserRepost,
    this.profilePhotoUserRepost,
    required this.createdAtRepost,
    this.mediaUrlsRepost,
    required this.onRepostTap,
    this.onPostTap,
    this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRepostTap,
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
              if (body != null && body != '')
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    body!,
                    style: const TextStyle(fontSize: 14),
                ),
              ),
              // Agregar el PostWidget interno
              PostWidgetInternal(
                nameUser: nameUserRepost,
                usernameUser: usernameUserRepost,
                profilePhotoUser: profilePhotoUserRepost,
                createdAt: createdAtRepost,
                mediaUrls: mediaUrlsRepost,
                body: bodyRepost,
                onTap: () {
                  onPostTap!();
                },
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
  final String nameUser;
  final String usernameUser;
  final String? profilePhotoUser;
  final DateTime createdAt;
  final String? body;
  final List<String>? mediaUrls;
  final VoidCallback onTap;
  final VoidCallback? onProfileTap;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final double avatarSize;
  final double iconSize;

  PostWidgetInternal({
    Key? key,
    required this.nameUser,
    required this.usernameUser,
    this.profilePhotoUser,
    required this.createdAt,
    this.body,
    this.mediaUrls,
    required this.onTap,
    this.onProfileTap,
    this.color,
    this.margin,
    this.avatarSize = 25.0,
    this.iconSize = 15.0
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
        padding:const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: color ?? AppColors.whiteapp,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.whiteapp, // Color del borde
            width: 1, // Grosor del borde
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
                  avatarSize: avatarSize,
                  iconSize: iconSize,
                  onPressed: onProfileTap,
                ),
                const SizedBox(width: 5),
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
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatDate(createdAt),
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '@$usernameUser',
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 13,
                        ),
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
                child: Text(
                  body!,
                  style: const TextStyle(fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CommentSimpleWidget extends StatelessWidget {
  final String nameUser;
  final String usernameUser;
  final String? profilePhotoUser;
  final DateTime createdAt;
  final String? body;
  final String? mediaUrl;
  final VoidCallback? onProfileTap;
  final VoidCallback? onCommentTap;

  CommentSimpleWidget({
    Key? key,
    required this.nameUser,
    required this.usernameUser,
    required this.createdAt,
    this.profilePhotoUser,
    this.body,
    this.mediaUrl,
    this.onProfileTap,
    this.onCommentTap,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    const double mediaHeight = 250.0;
    const double mediaWidth = double.infinity;
    return GestureDetector(
      onTap: onCommentTap,
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
      )
    );
  }
}

class ReportUserWidget extends StatelessWidget {
  final String nameUser;
  final String usernameUser;
  final String? profilePhotoUser;
  final DateTime createdAt;
  final String observation;
  final String report;
  final VoidCallback? onProfileTap;

  ReportUserWidget({
    Key? key,
    required this.nameUser,
    required this.usernameUser,
    required this.createdAt,
    this.profilePhotoUser,
    required this.observation,
    required this.report,
    this.onProfileTap,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 58.0,
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
                Text(
                  'Reporto este ${report} por:', // Manejo de caso nulo
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  observation,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.errorRed,
                  ),
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
      ),
    );
  }
}


