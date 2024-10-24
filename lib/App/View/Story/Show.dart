import 'dart:async';
import 'package:escuchamos_flutter/Api/Command/StoryCommand.dart';
import 'package:escuchamos_flutter/Api/Model/StoryModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Service/StoryService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Story/FullScreemStory.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  int _currentStoryIndex = 0;
  Timer? _timer; // Para el temporizador
  List<double> _progressList = []; // Progreso de cada historia
  bool _isPaused = false; // Estado de pausa del temporizador

  ValueNotifier<int> currentStoryId = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _callStory();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancelar el temporizador cuando se destruya el widget
    currentStoryId.dispose(); // Limpiar el ValueNotifier
    super.dispose();
  }

  Future<void> _callStory() async {
    final storyCommand = StoryGroupedCommandShow(StoryGroupedShow(), widget.userId);
      try {
          final response = await storyCommand.execute();
          if (mounted) {
              if (response is StoryGroupedModel) {
                  setState(() {
                      _story = response;
                      _username = _story?.data.user.username;
                      _profilePhotoUrl = _story?.data.user.profilePhotoUrl;
                      _stories = _story?.data.stories ?? [];
                      
                      // Inicializar lista de progreso
                      _progressList = List<double>.filled(_stories.length, 0.0); 

                       // Marcar las historias ya vistas en el progreso
                      for (int i = 0; i < _stories.length; i++) {
                        if (_stories[i].isRead) {
                          _progressList[i] = 1.0; // Marca como llena si ya fue vista
                        } else {
                          _progressList[i] = 0.0; // Asegúrate de que el progreso de las historias no vistas empiece en 0.0
                          // Aquí encontramos la primera historia no vista
                          _currentStoryIndex = i; // Establece el índice en la primera historia no vista
                          break; // Salimos del bucle una vez encontrado
                        }
                      }
                  });
                  // Iniciar el temporizador para cambiar historias
                  _startTimer();
              } else {
                  showDialog(
                      context: context,
                      builder: (context) => PopupWindow(
                          title: response is InternalServerError ? 'Error' : 'Error de Conexión',
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

  Future<void> _postStoryView() async {
    try {
      var response = await StoryViewCommandPost(StoryViewPost()).execute(currentStoryId.value);
      if (response is SuccessResponse) {
        print('Solicitud exitosa $response');
      } else if (response == 1) {
        print('Solicitud exitosa, pero sin contenido (204)');
      } else {
        await showDialog(
          context: context,
          builder: (context) => AutoClosePopupFail(
            child: const FailAnimationWidget(),
            message: response.message,
          ),
        );
      }
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) => PopupWindow(
          title: 'Error',
          message: e.toString(),
        ),
      );
    }
  }
  
  void _resetTimer() {
    _startTimer(); // Reiniciar el temporizador
  }

  void _startTimer() {
    _timer?.cancel(); // Cancelar el temporizador anterior
    _progressList[_currentStoryIndex] = 0.0; // Reiniciar el progreso para la historia actual

    // Actualizar el ID de la historia actual
    currentStoryId.value = _stories[_currentStoryIndex].id;

    // **Llamada a la función para registrar la visualización de la historia**
    _postStoryView(); // Llamar a la función para enviar la visualización de la historia

    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (!_isPaused) { // Solo actualizar si no está pausado
        if (_progressList[_currentStoryIndex] < 1.0) {
          setState(() {
            _progressList[_currentStoryIndex] += 0.01; // Incrementar el progreso
          });
        } else {
          if (_currentStoryIndex < _stories.length - 1) {
            setState(() {
              _currentStoryIndex++; // Avanzar a la siguiente historia
              _progressList[_currentStoryIndex] = 0.0; // Reiniciar el progreso para la nueva historia
            });
            // Actualizar el ID de la historia actual
            currentStoryId.value = _stories[_currentStoryIndex].id;

            // **Registrar visualización de la nueva historia**
            _postStoryView(); // Llamar a la función para enviar la visualización de la historia
          } else {
            _timer?.cancel(); // Cancelar el temporizador
            Navigator.of(context).pop(); // Cerrar la vista cuando se terminen las historias
          }
        }
      }
    });
  }

  void _nextStory() {
    if (_currentStoryIndex < _stories.length - 1) {
      setState(() {
        _progressList[_currentStoryIndex] = 1.0; // Marca la historia anterior como llena
        _currentStoryIndex++;
        _progressList[_currentStoryIndex] = 0.0; // Reiniciar el progreso para la siguiente
      });
      
      // Actualizar el ID de la historia actual
      currentStoryId.value = _stories[_currentStoryIndex].id;

      // **Registrar visualización de la nueva historia**
      _postStoryView(); // Llamar a la función para enviar la visualización de la historia

      _resetTimer(); // Reiniciar el temporizador al navegar a la siguiente historia
    } else {
      Navigator.of(context).pop(); // Cerrar la vista si no hay más historias
    }
  }

  void _previousStory() {
    if (_currentStoryIndex > 0) {
      setState(() {
        _progressList[_currentStoryIndex] = 1.0; // Marca la historia actual como llena
        _currentStoryIndex--;
        _progressList[_currentStoryIndex] = 0.0; // Reiniciar el progreso para la historia anterior
      });

      // Actualizar el ID de la historia actual
      currentStoryId.value = _stories[_currentStoryIndex].id;

      // **Registrar visualización de la nueva historia**
      _postStoryView(); // Llamar a la función para enviar la visualización de la historia

      _resetTimer(); // Reiniciar el temporizador al navegar a la historia anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteapp,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0) { // Detecta movimiento hacia abajo
            Navigator.of(context).pop(); // Cierra la vista
          }
        },
        onLongPressStart: (details) {
          setState(() {
            _isPaused = true; // Pausar el temporizador
          });
        },
        onLongPressEnd: (details) {
          setState(() {
            _isPaused = false; // Reanudar el temporizador
          });
        },
        child: _stories.isNotEmpty
            ? Stack(
                children: [
                  Center(
                    child: FullScreenStory(
                      imageUrl: _stories[_currentStoryIndex].relationships.file.first.attributes.url,
                      username: _username ?? '...',
                      timestamp: _formatTimestamp(_stories[_currentStoryIndex].attributes.createdAt),
                      profileAvatarUrl: _profilePhotoUrl,
                    ),
                  ),
                  Positioned(
                    top: 40, // Ajusta esta posición para elevar las barras de progreso
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Centrar las barras de progreso
                      children: [
                        for (int i = 0; i < _stories.length; i++)
                          Row(
                            children: [
                              Container(
                                width: (MediaQuery.of(context).size.width / _stories.length) - 16, // Ancho proporcional menos espacio
                                height: 2, // Altura de la barra (más pequeña)
                                child: LinearProgressIndicator(
                                  value: _progressList[i], // Valor del progreso específico de cada historia
                                  backgroundColor: Colors.grey.withOpacity(0.5),
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.greyLigth), // Color de la barra
                                ),
                              ),
                              // Espacio entre las barras
                              if (i < _stories.length - 1) const SizedBox(width: 8), // Separación entre barras
                            ],
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2 - 25, // Centra verticalmente los botones
                    left: 16, // Espacio a la izquierda para el botón de atrás
                    child: _currentStoryIndex > 0
                        ? _buildNavigationButton(Icons.arrow_back, _previousStory)
                        : SizedBox.shrink(), // Oculta el botón si no hay historias anteriores
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2 - 25, // Centra verticalmente los botones
                    right: 16, // Espacio a la derecha para el botón de adelante
                    child: _currentStoryIndex < _stories.length - 1
                        ? _buildNavigationButton(Icons.arrow_forward, _nextStory)
                        : SizedBox.shrink(), // Oculta el botón si no hay historias siguientes
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue)),
      ),
    );
  }

  Widget _buildNavigationButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 40, // Ancho del contenedor
      height: 40, // Altura del contenedor
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.withOpacity(0.5), // Color de fondo gris
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.whiteapp), // Color del ícono
        onPressed: onPressed,
        padding: EdgeInsets.zero, // Eliminar padding adicional
      ),
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
      return '${difference.inDays} día';
    }
  }
}
