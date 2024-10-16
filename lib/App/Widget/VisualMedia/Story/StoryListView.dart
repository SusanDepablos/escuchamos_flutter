import 'package:escuchamos_flutter/App/Widget/VisualMedia/Story/FullScreemStory.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class StoryList extends StatelessWidget {
  final String imageUrl;
  final String username;
  final bool showAddIcon;
  final bool isGradientBorder; // Para elegir el tipo de borde
  final bool showBorder; // Para controlar la visibilidad del borde

  const StoryList({
    Key? key,
    required this.imageUrl,
    required this.username,
    this.showAddIcon = false, // Valor predeterminado para que el ícono no aparezca si no se especifica
    this.isGradientBorder = true, // Por defecto, se utiliza el borde degradado
    this.showBorder = true, // Por defecto, el borde se muestra
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            // Imagen circular de la historia con borde degradado o sólido
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navega a la pantalla de historia en pantalla completa
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenStory(
                          imageUrl: imageUrl,
                          username: username,
                          timestamp: "Hace 5 minutos", // Cambia esto por la hora real que necesites
                          profileAvatarUrl: imageUrl, // Reemplaza con la URL del avatar real
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Se añade la condición para mostrar el borde
                      gradient: showBorder && isGradientBorder
                          ? const LinearGradient(
                              colors: [
                                AppColors.primaryBlue,
                                AppColors.deepPurple,
                                AppColors.errorRed,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      border: showBorder && !isGradientBorder
                          ? Border.all(color: AppColors.grey, width: 2.0) // Borde sólido gris
                          : null,
                    ),
                    child: Center(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.whiteapp,
                        ),
                        child: Center(
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Muestra el ícono de "add" solo si `showAddIcon` es verdadero
                if (showAddIcon)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryBlue,
                        border: Border.all(color: AppColors.whiteapp, width: 2.0),
                      ),
                      child: const Icon(
                        MaterialIcons.add,
                        size: 16,
                        color: AppColors.whiteapp,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4.0),
            Container(
              width: 60, // Ancho fijo para que todos los nombres tengan la misma distancia
              child: Text(
                username,
                style: const TextStyle(
                  fontSize: AppFond.text,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, // Muestra '...' si el texto es muy largo
                softWrap: false,
                maxLines: 1,
              ),
            ),
          ],
        ),
      )
    );
  }
}
