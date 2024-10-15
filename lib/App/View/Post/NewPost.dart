import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:escuchamos_flutter/Constants/Constants.dart'; // Asegúrate de que los colores estén definidos en este archivo
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart'; 
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart'; // Asegúrate de que el BasicTextArea esté definido aquí
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Post/AddFile.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/Api/Command/PostCommand.dart';
import 'package:escuchamos_flutter/Api/Service/PostService.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState(); // Cambié el nombre aquí
}

class _NewPostState extends State<NewPost> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  UserModel? _user;
  String? name;
  String? username;
  int? groupId;
  bool isEscuchamos = false; // Variable para el checkbox

  final input = {
    'body': TextEditingController(),
  };

  final _borderColors = {
    'body': AppColors.inputLigth,
  };

  final Map<String, String?> _errorMessages = {
    'body': null,
  };

  List<File> _mediaFiles = []; // Lista para almacenar archivos multimedia
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    _callUser();
  }
  

  String? _getFileUrlByType(String type) {
    try {
      final file = _user?.data.relationships.files.firstWhere(
        (file) => file.attributes.type == type,
      );
      return file?.attributes.url;
    } catch (e) {
      return null;
    }
  }

  Future<void> _callUser() async {
    final user = await _storage.read(key: 'user') ?? '0';
    final id = int.parse(user);
    final userCommand = UserCommandShow(UserShow(), id);

    try {
      final response = await userCommand.execute();

      if (mounted) {
        if (response is UserModel) {
          setState(() {
            _user = response;
            name = _user!.data.attributes.name;
            username = _user!.data.attributes.username;
            groupId = _user!.data.relationships.groups[0].id;
          });
        } else {
          await showDialog(
          context: context,
          builder: (context) => AutoClosePopupFail(
            child: const FailAnimationWidget(), // Aquí se pasa la animación
            message: response.message,
          ),
        );
      }
      }
    } catch (e) {
      print(e);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error de Flutter',
            message: 'Espera un poco, pronto lo solucionaremos.',
          ),
        );
      }
    }
  }

  Future<void> _postCreate() async {
    setState(() {
      submitting = true; // Activa el indicador de carga
    });
    try {
      int typePost;

      // Asigna el tipo de publicación basado en isEscuchamos
      if (isEscuchamos) {
        typePost = 4; // Tipo de publicación 4 si isEscuchamos es true
      } else {
        typePost = _mediaFiles.isNotEmpty ? 2 : 1; // 2 si hay archivos, 1 si no hay
      }

      var response = await PostCommandCreate(PostCreate()).execute(
        body: input['body']!.text,
        files: _mediaFiles, // Pasa el archivo seleccionado
        typePost: typePost, // Pasa el tipo: 'profile' o 'cover'

      );

      if (response is ValidationResponse) {
        if (response.key['body'] != null) {
          setState(() {
            _borderColors['body'] = AppColors.inputLigth;
            _errorMessages['body'] = response.message('body');
          });
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _borderColors['body'] = AppColors.inputLigth;
              _errorMessages['body'] = null;
            });
          });
        }
      } else if (response is SuccessResponse) {
        showDialog(
          context: context,
          builder: (context) => AutoClosePopup(
            child: const SuccessAnimationWidget(), // Aquí se pasa la animación
            message: response.message,
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            'base', // Nombre de la ruta que se desea cargar
            (Route<dynamic> route) => false, // Elimina todas las rutas anteriores
          );
        }); // Navega al home
      } else
        await showDialog(
          context: context,
          builder: (context) => AutoClosePopupFail(
            child: const FailAnimationWidget(), // Aquí se pasa la animación
            message: response.message,
          ),
        );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => PopupWindow(
          title: 'Error',
          message: e.toString(),
        ),
      );
    } finally {
      // Asegúrate de restablecer el estado de submitting
      setState(() {
        submitting = false; // Desactiva el indicador de carga
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? profileAvatarUrl = _getFileUrlByType('profile');
    ImageProvider? imageProvider;

    if (profileAvatarUrl != null && profileAvatarUrl.isNotEmpty) {
      imageProvider = NetworkImage(profileAvatarUrl);
    }

    return Scaffold(
      backgroundColor: AppColors.whiteapp,
      appBar: AppBar(
        backgroundColor: AppColors.whiteapp,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuir el espacio
          children: [
            // Espaciador vacío para empujar "Crear Publicación" al centro
            const Text(
              'Crear Publicación',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
            ),
            GenericButton(
              label: 'Publicar',
              onPressed: () {
                _postCreate(); // Llama a la función cuando se presiona
              },
              width: 90,
              height: 20,
              size: 14,
              isLoading: submitting,
              borderRadius: 24
            ),
          ],
        ),
      ),
      body: SingleChildScrollView( // Agregado para habilitar el scroll
        child: Column(
          children: [
            const Divider(
              thickness: 1,
              color: AppColors.inputLigth,
              indent: 16,
              endIndent: 16,
            ),
            // Mostrar el ProfileAvatar, name y username
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ProfileAvatar(
                    avatarSize: 40.0,
                    imageProvider: imageProvider,
                    showBorder: true,
                    onPressed: () {
                      // Aquí puedes abrir el drawer o realizar otra acción
                    },
                  ),
                  const SizedBox(width: 8), // Espacio entre el avatar y el texto
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7, // Ajusta el ancho según sea necesario
                        child: Row(
                          children: [
                            // El nombre de usuario
                            Text(
                              username ?? '...', // Asegúrate de que 'username' no sea null
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 4), // Espacio entre el nombre y el ícono de verificación
                            // Aquí va el ícono de verificación
                            if (groupId == 1 || groupId == 2) // Asegúrate de definir isVerified
                              const Icon(
                                CupertinoIcons.checkmark_seal_fill,
                                size: 16,
                                color: AppColors.primaryBlue, // Cambia el color según prefieras
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextArea(
                input: input['body']!,
                border: _borderColors['body']!,
                error: _errorMessages['body'],
                minLines: _mediaFiles.isNotEmpty ? 2 : 6,
              ),
            ),
            if (groupId == 1 || groupId == 2) // Muestra el checkbox si groupId es 1 o 2
            CheckboxListTile(
              title: const Text("Publicar como EscuChamos"),
              value: isEscuchamos,
              activeColor: AppColors.primaryBlue,
              onChanged: (bool? value) {
                setState(() {
                  isEscuchamos = value ?? false;
                });
              },
            ),
            const SizedBox(height: 16),
            ImagePickerWidget(
              onMediaChanged: (mediaFiles) {
                setState(() {
                  _mediaFiles = mediaFiles; // Actualiza la lista de archivos seleccionados
                });
              },
            ),  // Agrega el widget de selección de imágenes
          ],
        ),
      ),
    );
  }
}
