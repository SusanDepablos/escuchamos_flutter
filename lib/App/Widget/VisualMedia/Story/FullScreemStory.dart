import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class FullScreenStory extends StatelessWidget {
  final String imageUrl;
  final String username;
  final String timestamp; // Hora de la historia
  final String? profileAvatarUrl; // URL del avatar de perfil

  const FullScreenStory({
    Key? key,
    required this.imageUrl,
    required this.username,
    required this.timestamp,
    this.profileAvatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro para pantalla completa
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context); // Cierra la pantalla al tocar
        },
        child: Stack(
          children: [
            // Imagen de la historia en pantalla completa
            Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            // Contenedor para el avatar de perfil y texto
            Positioned(
              top: 50,
              left: 16,
              child: Row(
                children: [
                  ProfileAvatar(
                    avatarSize: 35.0,
                    iconSize: 30.0,
                    imageProvider: profileAvatarUrl != null
                        ? NetworkImage(profileAvatarUrl!)
                        : null,
                    onPressed: () {
                      // Acción cuando se presiona el avatar
                      print("Avatar de $username tocado");
                    },
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        timestamp,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
