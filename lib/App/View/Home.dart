import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:escuchamos_flutter/Constants/Constants.dart'; 
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Posts/PostList.dart';

class Home extends StatelessWidget {
  // Lista de usuarios de ejemplo
  final List<Map<String, dynamic>> users = [
    // Ejemplos de usuarios
    {
      'name': 'John Doe',
      'username': 'johndoe',
      'profile_photo_url': 'https://escuchamos-mcu6.onrender.com/media/photos_user/a9fe91dd-c81a-46d8-acb4-92f3a7702b2c.jpg',
      'body': 'Buenos dias como estas',
      'media_url': 'https://escuchamos-mcu6.onrender.com/media/photos_user/a9fe91dd-c81a-46d8-acb4-92f3a7702b2c.jpg', // Ejemplo de URL de video
      'reactions_count': '5',
      'comments_count': '5',
      'shares_count': '5',
    },
    {
      'name': 'Jane Smith',
      'username': 'janesmith',
      'profile_photo_url': 'https://escuchamos-mcu6.onrender.com/media/photos_user/a9fe91dd-c81a-46d8-acb4-92f3a7702b2c.jpg',
      'body': null,
      'media_url': 'https://escuchamos-mcu6.onrender.com/media/photos_user/a9fe91dd-c81a-46d8-acb4-92f3a7702b2c.jpg', // Ejemplo de URL de imagen
      'reactions_count': '5',
      'comments_count': '5',
      'shares_count': '5',
    },
    {
      'name': 'Jane Smith',
      'username': 'janesmith',
      'profile_photo_url': 'https://escuchamos-mcu6.onrender.com/media/photos_user/a9fe91dd-c81a-46d8-acb4-92f3a7702b2c.jpg',
      'body': 'buenasssssssssssss',
      'media_url': null, // Ejemplo de URL de imagen
      'reactions_count': '5',
      'comments_count': '5',
      'shares_count': '5',
    },
    {
      'name': 'Jane Smith',
      'username': 'janesmith',
      'profile_photo_url': 'https://escuchamos-mcu6.onrender.com/media/photos_user/a9fe91dd-c81a-46d8-acb4-92f3a7702b2c.jpg',
      'body': 'buenasssssssssssss',
      'media_url': 'https://escuchamos-mcu6.onrender.com/media/posts/554eb0a1-3a97-405d-a066-f0c0f1f8e85f.mp4', 
      'reactions_count': '5',
      'comments_count': '5',
      'shares_count': '5',
    },
    // Más usuarios...
  ];

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> _getData() async {
    final token = await _storage.read(key: 'token') ?? '';
    final session_key = await _storage.read(key: 'session_key') ?? '';
    final groupsString = await _storage.read(key: 'groups') ?? '[]';
    final groups = (groupsString.isNotEmpty) ? List<dynamic>.from(json.decode(groupsString)) : [];

    return {
      'token': token,
      'session_key': session_key,
      'groups': groups,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final data = snapshot.data!;
        final token = data['token'] as String;
        final session_key = data['session_key'] as String;
        final groups = data['groups'] as List<dynamic>;

        return Scaffold(
          backgroundColor: AppColors.whiteapp,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Token: $token', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Text('Session: $session_key', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Text('Groups: ${groups.join(', ')}', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return PostWidget(
                        nameUser: user['name']!,
                        usernameUser: user['username']!,
                        profilePhotoUser: user['profile_photo_url']!,
                        body: user['body'] as String?, // Permitir null aquí
                        mediaUrl: user['media_url'] as String?, // URL de media opcional
                        createdAt: DateTime.now(),
                        reactionsCount: user['reactions_count']!,
                        commentsCount: user['comments_count']!,
                        sharesCount: user['shares_count']!,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}