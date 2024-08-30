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

  void _openImagePicker(bool isCoverPhoto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImagePickerDialog(
          onImagePicked: (imageFile) {
            setState(() {
              // Muestra la vista previa de la imagen seleccionada
              _showImagePreview(imageFile, isCoverPhoto);
            });
          },
        );
      },
    );
  }
  void _showImagePreview(File imageFile, bool isCoverPhoto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vista Previa'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                setState(() {
                  // Guarda la imagen seleccionada
                  if (isCoverPhoto) {
                    _coverPhoto = imageFile;
                  } else {
                    _profileAvatar = imageFile;
                  }
                });
              },
              child: Text('Confirmar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
  void _confirmImageSelection() {
    setState(() {
      if (_isCoverPhoto) {
        _coverPhoto = _imageToPreview;
      } else {
        _profileAvatar = _imageToPreview;
      }
      _imageToPreview = null;
      _showPreview = false;
    });
    Navigator.of(context).pop(); // Close the preview dialog
  }

  void _cancelImageSelection() {
    setState(() {
      _imageToPreview = null;
      _showPreview = false;
    });
    Navigator.of(context).pop(); // Close the preview dialog
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
            input['name']!.text = _user!.data.attributes.name;
            input['biography']!.text = _user!.data.attributes.biography ?? '';
            input['birthdate']!.text = _user!.data.attributes.birthdate.toString().substring(0, 10);
            username = _user!.data.attributes.username;
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

  @override
  void initState() {
    super.initState();
    _callUser();
  }

  Future<void> _updateUser() async {
    setState(() {
      _submitting = true;
    });

    try {
      var response = await UserCommandUpdate(UserUpdate()).execute(
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
                  fontWeight: FontWeight.w500, // Negrita básica
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
              clipBehavior: Clip.none, // Permite que el contenido fuera del contenedor sea visible
              alignment: Alignment.center,
              children: [
                CoverPhoto(
                  height: 140.0, // Altura deseada
                  onPressed: () => _openImagePicker(true),
                ),
                Positioned(
                  bottom: -35, // Ajusta este valor para que la mitad del avatar esté fuera de la foto de portada
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: ProfileAvatar(
                        avatarSize: 70.0,
                        iconSize: 40.0,
                        onPressed: () => _openImagePicker(false),
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