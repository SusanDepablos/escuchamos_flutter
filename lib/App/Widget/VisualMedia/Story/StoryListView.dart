import 'package:escuchamos_flutter/App/Widget/VisualMedia/Story/FullScreemStory.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class StoryList extends StatelessWidget {
  final String? profilePhotoUser;
  final String username;
  final bool showAddIcon;
  final bool isGradientBorder; // Para elegir el tipo de borde
  final bool showBorder; // Para controlar la visibilidad del borde
  final bool isMyStory;
  final VoidCallback? onIconTap;
  final VoidCallback? onStoryTap;

  const StoryList({
    Key? key,
    required this.profilePhotoUser,
    required this.username,
    this.showAddIcon = false, // Valor predeterminado para que el ícono no aparezca si no se especifica
    this.isGradientBorder = false, // Por defecto, se utiliza el borde degradado
    this.showBorder = true, // Por defecto, el borde se muestra
    this.isMyStory = false,
    this.onIconTap,
    this.onStoryTap,
  }) : super(key: key);

  void _showStoryOptionsModal(BuildContext context, String? profilePhotoUser, String username) {
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
                  MaterialIcons.add,
                  size: 22,
                ),
                title: const Text(
                  'Subir nueva historia',
                  style: TextStyle(color: AppColors.black, fontSize: AppFond.subtitle),
                ),
                onTap: () {
                  Navigator.pop(context); // Cerrar el modal
                  onIconTap!(); // Llama a la función proporcionada
                },
              ),
                ListTile(
                  leading: const Icon(CupertinoIcons.eye_fill, size: 22),
                  title: const Text(
                    'Ver historia',
                    style: TextStyle(color: AppColors.black, fontSize: AppFond.subtitle),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Cerrar el modal
                    onStoryTap!();
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
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            // Imagen circular de la historia con borde degradado o sólido
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isMyStory && !showAddIcon) {
                      _showStoryOptionsModal(context, profilePhotoUser, username);
                    } else if (!showAddIcon) {
                      // Si no es su propia historia y no se muestra el ícono de agregar
                      onStoryTap!();
                    }
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Se añade la condición para mostrar el borde
                      gradient: showBorder && isGradientBorder == false
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
                      border: showBorder && isGradientBorder == true
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
                              image: profilePhotoUser != null && profilePhotoUser!.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(profilePhotoUser!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              color: AppColors.inputLigth, // Color de fondo si no hay imagen
                            ),
                            child: profilePhotoUser == null || profilePhotoUser!.isEmpty
                                ? const Icon(
                                    CupertinoIcons.person_fill, // Icono que se muestra si no hay imagen
                                    color: AppColors.inputDark,
                                    size: 24,
                                  )
                                : null,
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
                    child: GestureDetector(
                      onTap: onIconTap, // Ejecuta la función al tocar el ícono
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
      ),
    );
  }
}
