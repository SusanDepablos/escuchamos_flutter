import 'package:flutter/material.dart';
import 'dart:io';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Input.dart';
import 'package:escuchamos_flutter/App/Widget/Button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/CoverPhoto.dart'; // Importa el nuevo widget
import 'package:escuchamos_flutter/App/Widget/ProfileAvatar.dart'; 
import 'package:escuchamos_flutter/App/Widget/ImagePickerDialog.dart'; 
import 'package:escuchamos_flutter/App/Widget/FilePreview.dart'; 

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
    'biography': AppColors.inputBasic,
    'birthdate': AppColors.inputBasic
  };

  final Map<String, String?> _errorMessages = {
    'name': null,
    'biography': null,
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
            input['birthdate']!.text = _user!.data.attributes.birthdate.toString().substring(0, 10);
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
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error',
            message: e.toString(),
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

    void _openImagePicker(bool isCoverPhoto) async {
    final imageFile = await showDialog<File>(
      context: context,
      builder: (BuildContext context) {
        return ImagePickerDialog(
          onImagePicked: (imageFile) {
            Navigator.of(context).pop(imageFile);
          },
        );
      },
    );

    if (imageFile != null) {
      setState(() {
        _isCoverPhoto = isCoverPhoto;
        _imageToPreview = imageFile;
        _showImagePreview();
      });
    }
  }

  void _showImagePreview() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImagePreview(
          image: _imageToPreview,
          onConfirm: _confirmImageSelection,
          onCancel: _cancelImageSelection,
          isCoverPhoto: _isCoverPhoto,
        );
      },
    );
  }

  void _confirmImageSelection() async {
    setState(() {
      if (_isCoverPhoto) {
        _coverPhoto = _imageToPreview;
      } else {
        _profileAvatar = _imageToPreview;
      }
      _imageToPreview = null;
      _showPreview = false;
    });

    Navigator.of(context).pop(); // Cierra el diálogo de previsualización

    // Subir la imagen después de que se confirme la selección
    if (_coverPhoto != null && _isCoverPhoto) {
      await _uploadPhoto(_coverPhoto!, 'cover');
    } else if (_profileAvatar != null && !_isCoverPhoto) {
      await _uploadPhoto(_profileAvatar!, 'profile');
    }
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
      } else {
        // Mostrar el diálogo con el mensaje de éxito o error
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: response is SuccessResponse
                ? 'Correcto'
                : response is InternalServerError
                    ? 'Error'
                    : 'Error de Conexión',
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

  Future<void> _updateUser() async {
    setState(() {
      _submitting = true;
    });

    try {
      var response = await ProfileCommandUpdate(ProfileUpdate()).execute(
        input['name']!.text,
        input['biography']!.text,
        input['birthdate']!.text
      );

      if (response is ValidationResponse) {
        
        if (response.key['name'] != null) {
          setState(() {
            _borderColors['name'] = AppColors.inputDark;
            _errorMessages['name'] = response.message('name');
          });
          Future.delayed(Duration(seconds: 2), () {
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
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _borderColors['birthdate'] = AppColors.inputBasic;
              _errorMessages['birthdate'] = null;
            });
          });
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: response is SuccessResponse
                ? 'Correcto'
                : response is InternalServerError
                    ? 'Error'
                    : 'Error de Conexión',
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
    } finally {
      setState(() {
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Editar Perfil',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              Text(
                '@${username ?? '...'}',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.inputDark,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
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
                  iconSize: 50.0,
                  onPressed: () => _openImagePicker(true),
                  imageProvider: _coverPhoto != null
                      ? FileImage(_coverPhoto!)
                      : (_coverPhotoUrl != null
                          ? NetworkImage(_coverPhotoUrl!)
                          : null), // Imagen por defecto
                  ),
                Positioned(
                  bottom: -35,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: ProfileAvatar(
                        avatarSize: 70.0,
                        iconSize: 40.0,
                        onPressed: () => _openImagePicker(false),
                        imageProvider: _profileAvatar != null
                          ? FileImage(_profileAvatar!)
                          : (_profileAvatarUrl != null
                              ? NetworkImage(_profileAvatarUrl!)
                              : null) // Elimina AssetImage
                      , // Imagen por defecto
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60.0),
            GenericInput(
              text: 'Nombre y Apellido',
              input: input['name']!,
              border: _borderColors['name']!,
              error: _errorMessages['name'],
            ),
            SizedBox(height: 20.0),
            GenericInput(
              text: 'Biografía',
              input: input['biography']!,
              border: _borderColors['biography']!,
              error: _errorMessages['biography'],
            ),
            SizedBox(height: 20.0),
            DateInput(
              text: 'Fecha de Nacimiento',
              input: input['birthdate']!,
              border: _borderColors['birthdate']!,
              error: _errorMessages['birthdate'],
            ),
            SizedBox(height: 35.0),
            GenericButton(
              label: 'Actualizar',
              onPressed: _updateUser,
              isLoading: _submitting,
            ),
          ],
        ),
      ),
    );
  }
}