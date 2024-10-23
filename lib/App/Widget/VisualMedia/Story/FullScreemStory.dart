import 'dart:async'; // Importa el paquete para usar Timer
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingBasic.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class FullScreenStory extends StatefulWidget {
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
  _FullScreenStoryState createState() => _FullScreenStoryState();
}

class _FullScreenStoryState extends State<FullScreenStory> {
  late Timer _timer;
  double _progress = 0.0; // Progreso inicial

  @override
  void initState() {
    super.initState();
    // Cierra la historia después de 10 segundos
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_progress < 1.0) {
          _progress += 0.01; // Incrementa el progreso
        } else {
          timer.cancel(); // Cancela el timer cuando se complete
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancela el timer al eliminar el widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.black, // Fondo negro para pantalla completa
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // Cierra la pantalla al tocar
            },
            child: Stack(
              children: [
                // Imagen de la historia en pantalla completa
                Center(
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
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
                // Línea de progreso en la parte superior
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.white.withOpacity(0.2), // Color de fondo
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Color de progreso
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
                        imageProvider: widget.profileAvatarUrl != null
                            ? NetworkImage(widget.profileAvatarUrl!)
                            : null,
                        onPressed: () {
                          print("Avatar de ${widget.username} tocado");
                        },
                      ),
                      const SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: AppFond.label,
                            ),
                          ),
                          Text(
                            widget.timestamp,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
