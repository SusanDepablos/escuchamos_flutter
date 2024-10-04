import 'package:escuchamos_flutter/Api/Model/PostModels.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Post/RepostCreate.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart'; // Asegúrate de que los colores estén definidos en este archivo
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/Api/Command/PostCommand.dart';
import 'package:escuchamos_flutter/Api/Service/PostService.dart';


final FlutterSecureStorage _storage = FlutterSecureStorage();
class NewRepost extends StatefulWidget{
  final int postId;

  NewRepost({required this.postId});

  @override
  _NewRepostState createState() => _NewRepostState(); // Cambié el nombre aquí
}

class _NewRepostState extends State<NewRepost> {
  UserModel? _user;
  int _id = 0;
  String? name;
  String? username;
  String? profileAvatarUrl;
  PostModel? _post;
  String? _name;
  String? _username;
  String? _profilePhotoUrl;
  String? _body;
  DateTime? _createdAt;
  List<String>? _mediaUrls;
  bool _submitting = false;

  final input = {
    'body': TextEditingController(),
  };

  bool submitting = false;

  @override
  void initState() {
    super.initState();
    _getData()
    .then((_) {
      _callUser();
    });

    _callPost();
  }

  Future<void> _getData() async {
    final id = await _storage.read(key: 'user') ?? '';

    setState(() {
      _id = int.parse(id);
    });
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
    final userCommand = UserCommandShow(UserShow(), _id);

    try {
      final response = await userCommand.execute();

      if (mounted) {
        if (response is UserModel) {
          setState(() {
            _user = response;
            name = _user!.data.attributes.name;
            username = _user!.data.attributes.username;

            profileAvatarUrl = _getFileUrlByType('profile');
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

  Future<void> _repostCreate() async {
    setState(() {
      submitting = true;
    });
    try {
      print(input['body']!.text);
      var response = await PostCommandCreate(PostCreate()).execute(
        body: input['body']!.text,
        postId: widget.postId,
        typePost: 3, // Pasa el tipo: 'profile' o 'cover'

      );

      if (response is SuccessResponse) {
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

  Future<void> _callPost() async {
    final postCommand = PostCommandShow(PostShow(), widget.postId);
    try {
      final response = await postCommand.execute();
      if (mounted) {
        if (response is PostModel) {
          setState(() {
            _post = response; // Establecer _post aquí
            _name = _post?.data.relationships.user.name;
            _username = _post?.data.relationships.user.username;
            _profilePhotoUrl = _post?.data.relationships.user.profilePhotoUrl;
            _body = _post?.data.attributes.body;
            _createdAt = _post?.data.attributes.createdAt;
            _mediaUrls = _post?.data.relationships.files.map((file) => file.attributes.url).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteapp,
      appBar: AppBar(
        backgroundColor: AppColors.whiteapp,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuir el espacio
            children: [
              // Espaciador vacío para empujar "Crear Publicación" al centro
              Text(
                'Repostear',
                style: const TextStyle(
                  fontSize: AppFond.title,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              GenericButton(
                label: 'Publicar',
                onPressed: () {
                  _repostCreate(); // Llama a la función cuando se presiona
                },
                width: 90,
                height: 20,
                isLoading: submitting,
                borderRadius: 24
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding de 16 alrededor del widget
          child: RepostCreateWidget(
            nameUser: name ?? '',
            username: username ?? '',
            body: input['body']!.text,
            profilePhotoUser: profileAvatarUrl ?? '',
            isButtonDisabled: _submitting,
            bodyRepost: _body ?? '',
            nameUserRepost: _name ?? '',
            usernameUserRepost: _username ?? '',
            profilePhotoUserRepost: _profilePhotoUrl ?? '',
            createdAtRepost: _createdAt ?? DateTime.now(), // Valor por defecto si es null
            mediaUrlsRepost: _mediaUrls ?? [], // Lista vacía si es null
            onPostTap: () {
              // Acción al tocar el post
            },
            onProfileTapRepost: () {
              // Acción al tocar el perfil en el repost
            },
          ),
        ),
      )
    );
  }
}
