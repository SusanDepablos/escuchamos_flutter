import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Label.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/VideoPlayer.dart';

class PostWidget extends StatelessWidget {
  final String nameUser;
  final String usernameUser;
  final String? profilePhotoUser;
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
    required this.createdAt,
    this.reactionsCount = '120',
    this.commentsCount = '45',
    this.sharesCount = '30',
    this.body,
    this.mediaUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
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
                  imageProvider: NetworkImage(profilePhotoUser ?? ''),
                  avatarSize: 40.0,
                  showBorder: true,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            nameUser,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
                child: mediaUrl!.endsWith('.mp4')
                    ? VideoPlayerWidget(videoUrl: mediaUrl!)
                    : Image.network(mediaUrl!, fit: BoxFit.cover),
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
