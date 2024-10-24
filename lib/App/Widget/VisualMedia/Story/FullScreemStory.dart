import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingBasic.dart';
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: AppColors.whiteapp, // Fondo claro
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              // Aquí puedes manejar el evento de tap si lo deseas
            },
            child: Stack(
              children: [
                // Imagen de la historia ajustada
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8, // Ajusta el ancho al 80%
                    height: MediaQuery.of(context).size.height * 0.8, // Ajusta la altura al 80%
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain, // Cambiado a BoxFit.contain
                      loadingBuilder: (context, child, loadingProgress) {
                        return child; 
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.greyLigth, // Fondo gris
                          child: Center(
                            child: CustomLoadingIndicator(color: AppColors.primaryBlue),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Sombras sutiles en la parte superior e inferior
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100, // Ajusta la altura de la sombra
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100, // Ajusta la altura de la sombra
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Contenedor para el avatar de perfil y texto
                Positioned(
                  top: 20,
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
                              fontSize: AppFond.label,
                            ),
                          ),
                          Text(
                            timestamp,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: AppFond.date,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Botón de tres puntos (izquierda) y cierre (X) (derecha)
                Positioned(
                  top: 20, // Alineado a la misma altura que el nombre de usuario
                  right: 16, // Pegado al borde derecho
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Aquí puedes agregar la lógica para abrir el menú de opciones
                          print("Ícono de tres puntos tocado");
                        },
                        child: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8.0), // Espacio entre los tres puntos y la "X"
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // Cerrar la vista
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
