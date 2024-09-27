import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/CoverPhoto.dart'; // Importa el nuevo widget
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/ImagePickerDialog.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/FilePreview.dart';
import 'package:image/image.dart' as img;

class EditProfile extends StatefulWidget {
  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<EditProfile> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  UserModel? _user;
  bool _submitting = false;
  String? username;
  File? _coverPhoto;
  File? _profileAvatar;
  File? _imageToPreview;
  bool _showPreview = false;
  bool _isCoverPhoto = true; // Flag to determine which image is being previewed

  final input = {
    'name': TextEditingController(),
    'biography': TextEditingController(),
    'birthdate': TextEditingController(),
  };

  final _borderColors = {
    'name': AppColors.inputBasic,
    'birthdate': AppColors.inputBasic
  };

  final Map<String, String?> _errorMessages = {
    'name': null,
    'birthdate': null,
  };

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
            input['name']!.text = _user!.data.attributes.name;
            input['biography']!.text = _user!.data.attributes.biography ?? '';
            String? birthdateStr = _user?.data.attributes.birthdate?.toString();
            input['birthdate']!.text =
                (birthdateStr != null && birthdateStr.length >= 10)
                    ? birthdateStr.substring(0, 10)
                    : '';
            username = _user!.data.attributes.username;
            // Buscar la URL para el avatar y la portada basándose en el tipo de archivo
            _profileAvatarUrl = _getFileUrlByType('profile');
            _coverPhotoUrl = _getFileUrlByType('cover');
          });
        } else {
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

  String? _profileAvatarUrl;
  String? _coverPhotoUrl;

  // Método auxiliar para obtener la URL del archivo por tipo
  String? _getFileUrlByType(String type) {
    try {
      final file = _user?.data.relationships.files.firstWhere(
        (file) => file.attributes.type == type,
      );
      return file!.attributes.url;
    } catch (e) {
      return null; // Retorna null si no se encuentra el archivo
    }
  }

  @override
  void initState() {
    super.initState();
    _callUser();
  }

  void reloadView() {
    _callUser();
  }

  Future<File> _compressImage(File file) async {
    final originalImage = img.decodeImage(await file.readAsBytes());

    // Redimensionar la imagen
    final resizedImage =
        img.copyResize(originalImage!, width: 800); // Ajusta según necesites

    // Codificar la imagen redimensionada a bytes
    final compressedBytes =
        img.encodeJpg(resizedImage, quality: 80); // Ajusta la calidad

    // Crear un archivo temporal para la imagen comprimida
    final tempFile = File('${file.parent.path}/temp_compressed.jpg');
    await tempFile.writeAsBytes(compressedBytes);

    return tempFile; // Devuelve el archivo comprimido
  }

  void _openImagePicker(bool isCoverPhoto) async {
    final imageFile = await showDialog<File>(
      context: context,
      builder: (BuildContext context) {
        return ImagePickerDialog(
          onImagePicked: (imageFile) {
            Navigator.of(context).pop(imageFile);
          },
          onDeletePhoto: () {
            _deletePhoto(isCoverPhoto ? 'cover' : 'profile');
            setState(() {
              if (isCoverPhoto) {
                _coverPhoto = null;
                _coverPhotoUrl = null;
              } else {
                _profileAvatar = null;
                _profileAvatarUrl = null;
              }
            });
            reloadView();
          },
          hasPhoto:
              isCoverPhoto ? _coverPhotoUrl != null : _profileAvatarUrl != null,
        );
      },
    );

    if (imageFile != null) {
      setState(() {
        _isCoverPhoto = isCoverPhoto;
        _imageToPreview = imageFile; // Guarda el archivo original
      });

      // Muestra la previsualización sin comprimir
      _showImagePreview(imageFile); // Muestra la imagen original
    }
  }

  void _showImagePreview(File originalImage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImagePreview(
          image: originalImage, // Muestra la imagen original
          onConfirm: () async {
            // Comprimir solo al confirmar
            final compressedImage = await _compressImage(originalImage);
            _confirmImageSelection(compressedImage);
          },
          onCancel: _cancelImageSelection,
          isCoverPhoto: _isCoverPhoto,
        );
      },
    );
  }

  void _confirmImageSelection(File compressedImage) async {
    setState(() {
      if (_isCoverPhoto) {
        _coverPhoto = compressedImage;
      } else {
        _profileAvatar = compressedImage;
      }
      _imageToPreview = null;
      _showPreview = false;
    });

    Navigator.of(context).pop(); // Cierra el diálogo de previsualización

    // Subir la imagen después de que se confirme la selección
    await _uploadPhoto(compressedImage, _isCoverPhoto ? 'cover' : 'profile');

    reloadView();
  }

  void _cancelImageSelection() {
    setState(() {
      _imageToPreview = null;
      _showPreview = false;
    });
    Navigator.of(context).pop(); // Close the preview dialog
  }

  Future<void> _uploadPhoto(File file, String type) async {
    try {
      var response = await UploadCommandPhoto(UploadPhoto()).execute(
        file: file, // Pasa el archivo seleccionado
        type: type, // Pasa el tipo: 'profile' o 'cover'
      );

      if (response is ValidationResponse) {
        // Manejo de validaciones, si es necesario
      } else if (response is SuccessResponse) {
        showDialog(
          context: context,
          builder: (context) => AutoClosePopup(
            child: const SuccessAnimationWidget(), // Aquí se pasa la animación
            message: response.message,
          ),
        );
      } else
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title:
                response is InternalServerError ? 'Error' : 'Error de Conexión',
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
    }
  }

  Future<void> _updateUser() async {
    setState(() {
      _submitting = true;
    });

    try {
      var response = await ProfileCommandUpdate(ProfileUpdate()).execute(
          input['name']!.text,
          input['biography']!.text,
          input['birthdate']!.text);

      if (response is ValidationResponse) {
        if (response.key['name'] != null) {
          setState(() {
            _borderColors['name'] = AppColors.inputDark;
            _errorMessages['name'] = response.message('name');
          });
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _borderColors['name'] = AppColors.inputBasic;
              _errorMessages['name'] = null;
            });
          });
        }

        if (response.key['birthdate'] != null) {
          setState(() {
            _borderColors['birthdate'] = AppColors.inputDark;
            _errorMessages['birthdate'] = response.message('birthdate');
          });
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _borderColors['birthdate'] = AppColors.inputBasic;
              _errorMessages['birthdate'] = null;
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
      setState(() {
        _submitting = false;
      });
    }
  }

  Future<void> _deletePhoto(String type) async {
    try {
      var response = await DeleteCommandPhoto(DeletePhoto()).execute(
        type: type, // Pasa el tipo: 'profile' o 'cover'
      );

      if (response is SuccessResponse) {
        // Mostrar el diálogo con el mensaje de éxito o error
        showDialog(
          context: context,
          builder: (context) => AutoClosePopup(
            child: const SuccessAnimationWidget(), // Aquí se pasa la animación
            message: response.message,
          ),
        );
      }
      else {
        await showDialog(
          context: context,
          builder: (context) => AutoClosePopupFail(
            child: const FailAnimationWidget(), // Aquí se pasa la animación
            message: response.message,
          ),
        );
      }
      } catch (e) {
      showDialog(
        context: context,
        builder: (context) => PopupWindow(
          title: 'Error',
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteapp,
      appBar: AppBar(
        backgroundColor: AppColors.whiteapp,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Editar Perfil',
                style: TextStyle(
                  fontSize: AppFond.title,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              Text(
                '@${username ?? '...'}',
                style: const TextStyle(
                  fontSize: AppFond.subtitle,
                  color: AppColors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Aquí agregas el SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  CoverPhoto(
                    height: 140.0,
                    iconSize: 40.0,
                    onPressed: () => _openImagePicker(true),
                    imageProvider: _coverPhoto != null
                        ? FileImage(_coverPhoto!)
                        : (_coverPhotoUrl != null
                            ? NetworkImage(_coverPhotoUrl!)
                            : null), // Imagen por defecto
                    isEditing: true,
                  ),
                  Positioned(
                    bottom: -30,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: ProfileAvatar(
                          avatarSize: 70.0,
                          iconSize: 30.0,
                          onPressed: () => _openImagePicker(false),
                          imageProvider: _profileAvatar != null
                              ? FileImage(_profileAvatar!)
                              : (_profileAvatarUrl != null
                                  ? NetworkImage(_profileAvatarUrl!)
                                  : null), // Imagen por defecto
                          isEditing: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60.0),
              GenericInput(
                maxLength: 35,
                text: 'Nombre y Apellido',
                input: input['name']!,
                border: _borderColors['name']!,
                error: _errorMessages['name'],
              ),
              const SizedBox(height: 20.0),
              BasicTextArea(
                text: 'Biografía',
                input: input['biography']!,
                maxLength: 70,
              ),
              const SizedBox(height: 20.0),
              DateInput(
                text: 'Fecha de Nacimiento',
                input: input['birthdate']!,
                border: _borderColors['birthdate']!,
                error: _errorMessages['birthdate'],
              ),
              const SizedBox(height: 35.0),
              GenericButton(
                label: 'Actualizar',
                onPressed: _updateUser,
                isLoading: _submitting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
