import 'package:escuchamos_flutter/Api/Command/StoryCommand.dart';
import 'package:escuchamos_flutter/Api/Model/StoryModels.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Service/StoryService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingBasic.dart';
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
  List<Datum> stories = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;
  bool _initialLoading = true;
  int page = 1;

  final filters = {
    'pag': '10',
    'page': null,
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          if (_hasMorePages && !_isLoading) {
            fetchStories();
          }
        }
      });
    _getData().then((_) {
      _callUser();
      _callStory();
    });
    fetchStories();
  }


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
    final storyCommand = StoryGroupedCommandShow(StoryGroupedShow(), _id);
    try {
      final response = await storyCommand.execute();
      if (mounted) {
        if (response is StoryGroupedModel) {
          setState(() {
            _showBorder = true;
            _story = response; // Establecer _post aquí
            _isGradientBorder = _story?.data.allRead;
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

  Future<void> fetchStories() async {
    if (_isLoading || !_hasMorePages) return;

    setState(() {
      _isLoading = true;
    });

    filters['page'] = page.toString();

    final storyCommand = StoryCommandIndex(StoryIndex(), filters);

    try {
      var response = await storyCommand.execute();

      if (response is StoriesModel) {
        setState(() {
          stories.addAll(response.results.data);
          _hasMorePages = response.next != null && response.next!.isNotEmpty;
          page++;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: response is InternalServerError ? 'Error de servidor' : 'Error de conexión',
            message: response.message,
          ),
        );
      }
    } catch (e) {
      print(e);
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error de Flutter',
            message: 'Espera un poco, pronto lo solucionaremos.',
          ),
        );
      }
    finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _initialLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteapp,
      body: CustomScrollView(
        slivers: [
          // Sección de historias desplazables horizontalmente
          SliverToBoxAdapter(
            child: Container(
              height: 100, // Ajusta la altura según lo necesites
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Desplazamiento horizontal
                controller: _scrollController, // Controlador del scroll
                itemCount: stories.length + 1 + (_isLoading ? 1 : 0), // +1 para la historia personalizada del usuario
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Mostrar la historia personalizada del usuario (el primer elemento)
                    return StoryList(
                      profilePhotoUser: _profilePhotoUrl ?? '',
                      username: _username ?? '...',
                      showAddIcon: _showAddIcon,
                      isGradientBorder: _isGradientBorder ?? true,
                      showBorder: _showBorder,
                      isMyStory: true,
                      onIconTap: () {
                        Navigator.pushNamed(context, 'new-story');
                      },
                      onStoryTap: () {
                        int userId = _id;
                        Navigator.pushNamed(
                          context,
                          'show-story',
                          arguments: {
                            'userId': userId,
                          }).then((_) {
                            _callStory();
                          },
                        );
                      },
                    );
                  }
                  if (index == stories.length + 1) {
                    // Mostrar un indicador de carga al final de la lista si está cargando más historias
                    return SizedBox(
                      width: 60.0, // Tamaño para el indicador de carga en horizontal
                      child: Center(
                        child: CustomLoadingIndicator(color: AppColors.primaryBlue),
                      ),
                    );
                  }
                  // Mostrar la historia correspondiente en cada índice después de la historia del usuario
                  final story = stories[index - 1]; // Restar 1 porque el primer elemento es la historia del usuario
                  return StoryList(
                    profilePhotoUser: story.user.profilePhotoUrl, 
                    username: story.user.username,
                  );
                },
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