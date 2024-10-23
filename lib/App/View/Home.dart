import 'package:escuchamos_flutter/Api/Command/StoryCommand.dart';
import 'package:escuchamos_flutter/Api/Model/StoryModels.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Service/StoryService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart' as user_model;
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/View/User/Profile/NavigatorUser.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Story/StoryListView.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Actualiza con la ruta correcta

FlutterSecureStorage _storage = FlutterSecureStorage();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  user_model.UserModel? _user;
  int _id = 0;
  StoryGroupedModel? _story;
  String? _username;
  String? _profilePhotoUrl;
  bool _showAddIcon = false;
  bool _showBorder = false;
  bool? _isGradientBorder;

  @override
  void initState() {
    super.initState();
    _getData().then((_) {
    _callUser();
    _callStory();
  });}

  Future<void> _getData() async {
    final id = await _storage.read(key: 'user') ?? '';

    setState(() {
      _id = int.parse(id);
    });
  }

  Future<void> _callUser() async {
    final userCommand = UserCommandShow(UserShow(), _id);

    try {
      final response = await userCommand.execute();

      if (mounted) {
        if (response is user_model.UserModel) {
          setState(() {
            _user = response;
            _username = _user!.data.attributes.username;
            _profilePhotoUrl = _getFileUrlByType('profile');
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


  Future<void> _callStory() async {
    final postCommand = StoryGroupedCommandShow(StoryGroupedShow(), _id);
    try {
      final response = await postCommand.execute();
      if (mounted) {
        if (response is StoryGroupedModel) {
          setState(() {
            _showBorder = true;
            _story = response; // Establecer _post aquí
            _isGradientBorder = _story?.data.allRead;
            // _username = _story?.data.user.username;
            // _profilePhotoUrl = _story?.data.user.profilePhotoUrl;
          });
        } else if (response is SimpleErrorResponse){
          setState(() {
            _showAddIcon = true;
            _showBorder = false;
          });
        }
        else {
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
      body: CustomScrollView(
        slivers: [
          // Sección de historias
          SliverToBoxAdapter(
            child: Container(
              height: 100, // Ajusta la altura según lo necesites
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  StoryList(
                    profilePhotoUser: _profilePhotoUrl ?? '',
                    username: _username ?? '...',
                    showAddIcon: _showAddIcon,
                    isGradientBorder: _isGradientBorder ?? true,
                    showBorder: _showBorder,
                    isMyStory: true,
                    onIconTap: () {
                      Navigator.pushNamed(context, 'new-story'); 
                    },
                  ),
                  StoryList(
                    profilePhotoUser: 'https://asociacioncivilescuchamos.onrender.com/media/photos_user/735d91fb-e21a-4838-9975-ad8213867af7.jpg',
                    username: 'juan.pablo',
                  ),
                  StoryList(
                    profilePhotoUser: 'https://asociacioncivilescuchamos.onrender.com/media/photos_user/735d91fb-e21a-4838-9975-ad8213867af7.jpg',
                    username: 'beele',
                  ),
                  StoryList(
                    profilePhotoUser: 'https://asociacioncivilescuchamos.onrender.com/media/photos_user/735d91fb-e21a-4838-9975-ad8213867af7.jpg',
                    username: 'susan.depablos.official',
                  ),
                  StoryList(
                    profilePhotoUser: 'https://asociacioncivilescuchamos.onrender.com/media/photos_user/735d91fb-e21a-4838-9975-ad8213867af7.jpg',
                    username: 'escuchamos',
                  ),
                  // Agrega más StoryList según sea necesario...
                ],
              ),
            ),
          ),
          // Espacio para el contenido principal
          SliverFillRemaining(
            child: NavigatorUser(
              initialTab: 'posts', // O 'shares', según la lógica que necesites
            ),
          ),
        ],
      ),
    );
  }
}
