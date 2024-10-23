import 'package:escuchamos_flutter/Api/Command/StoryCommand.dart';
import 'package:escuchamos_flutter/Api/Model/StoryModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Service/StoryService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Story/FullScreemStory.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Actualiza con la ruta correcta

FlutterSecureStorage _storage = FlutterSecureStorage();

class ShowStory extends StatefulWidget {
  final int userId;

  ShowStory({required this.userId});
  @override
  _ShowStoryState createState() => _ShowStoryState();
}

class _ShowStoryState extends State<ShowStory> {
  StoryGroupedModel? _story;
  String? _username;
  String? _profilePhotoUrl;
  List<Story> _stories = [];

  @override
  void initState() {
    super.initState();
      _callStory();
    }

  Future<void> _callStory() async {
    final storyCommand = StoryGroupedCommandShow(StoryGroupedShow(), widget.userId);
    try {
      final response = await storyCommand.execute();
      if (mounted) {
        if (response is StoryGroupedModel) {
          setState(() {
            _story = response; // Establecer _post aquí
            _username = _story?.data.user.username;
            _profilePhotoUrl = _story?.data.user.profilePhotoUrl;
            _stories = _story?.data.stories ?? [];
            print('Número de historias: ${_stories.length}');
          });
        }
        else {
          showDialog(
            context: context,
            builder: (context) => PopupWindow(
              title: response is InternalServerError
                  ? 'Error'
                  : 'Error de Conexión',
              message: response.message,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        print(e.toString());
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error de Flutter',
            message: e.toString(),
          ),
        );
      }
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteapp,
      body: _stories.isNotEmpty
          ? PageView.builder(
              itemCount: _stories.length,
              itemBuilder: (context, index) {
                final story = _stories[index];
                return FullScreenStory(
                  imageUrl: story.relationships.file.first.attributes.url,
                  username: _username ?? '...',
                  timestamp: _formatTimestamp(story.attributes.createdAt), // Asumiendo que hay un campo createdAt
                  profileAvatarUrl: _profilePhotoUrl,
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  String _formatTimestamp(DateTime createdAt) {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} segundos';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutos';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} horas';
    } else {
      return '${difference.inDays} días';
    }
  }

}