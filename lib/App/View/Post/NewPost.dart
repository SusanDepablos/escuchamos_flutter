import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart'; // Asegúrate de que los colores estén definidos en este archivo
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart'; 
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart'; // Asegúrate de que el BasicTextArea esté definido aquí

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState(); // Cambié el nombre aquí
}

class _NewPostState extends State<NewPost> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  UserModel? _user;
  String? name;
  String? username;

  final input = {
    'body': TextEditingController(),
  };

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
          });
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
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Crear Publicación',
                style: const TextStyle(
                  fontSize: AppFond.title,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Divider(
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
                SizedBox(width: 8), // Espacio entre el avatar y el texto
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? '...',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '@${username ?? '...'}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
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
            ),
          ),
          // Aquí puedes agregar más widgets para el contenido del body
        ],
      ),
    );
  }
}
