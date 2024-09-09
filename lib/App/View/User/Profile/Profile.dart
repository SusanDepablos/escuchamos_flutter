import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart' as UserModels;
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/CoverPhoto.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Label.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SettingsMenu.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/FullScreenImage.dart';
import 'package:escuchamos_flutter/Api/Command/AuthCommand.dart';
import 'package:escuchamos_flutter/Api/Service/AuthService.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Model/PostModels.dart' as PostModels;
import 'package:escuchamos_flutter/Api/Command/PostCommand.dart';
import 'package:escuchamos_flutter/Api/Service/PostService.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Posts/PostList.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/CustomRefreshIndicator.dart';

class Profile extends StatefulWidget {
  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Profile> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  UserModels.UserModel? _user;
  String? username;
  String? name;
  String? biography;
  int? followers;
  int? following;
  DateTime? createdAt;
  bool _submitting = false;
  List<PostModels.Datum> posts = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;
  int page = 1;
  int? userId;

  final filters = {
    'pag': '10',
    'page': '1',
    'user_id': ''
  };

  Future<void> _logout(BuildContext context) async {
    setState(() {
      _submitting = true;
    });
    final userCommandLogout = UserCommandLogout(UserLogout());

    try {
      // Ejecutar el comando de cierre de sesión
      final response = await userCommandLogout.execute();

      if (response is SuccessResponse) {
        await showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Correcto',
            message: response.message,
          ),
        );
        // Elimina el token y otros datos del almacenamiento seguro
        await _storage.delete(key: 'token');
        await _storage.delete(key: 'session_key');
        await _storage.delete(key: 'user');
        await _storage.delete(key: 'groups');

        // Redirige al usuario a la pantalla de login
        Navigator.pushNamedAndRemoveUntil(
          context,
          'login',
          (route) => false,
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error',
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
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  Future<void> _callUser() async {
    final user = await _storage.read(key: 'user') ?? '0';
    final id = int.parse(user);
    final userCommand = UserCommandShow(UserShow(), id);

    try {
      final response = await userCommand.execute();

      if (mounted) {
        if (response is  UserModels.UserModel) {
          setState(() {
            _user = response;
            userId = _user!.data.id; // Guardar el ID del usuario
            name = _user!.data.attributes.name;
            username = _user!.data.attributes.username;
            biography = _user!.data.attributes.biography;
            followers = _user!.data.relationships.followersCount;
            following = _user!.data.relationships.followingCount;
            createdAt = _user!.data.attributes.createdAt;
            _profileAvatarUrl = _getFileUrlByType('profile');
            _coverPhotoUrl = _getFileUrlByType('cover');

            filters['user_id'] = userId.toString();
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

  String? _getFileUrlByType(String type) {
    try {
      final file = _user?.data.relationships.files.firstWhere(
        (file) => file.attributes.type == type,
      );
      return file!.attributes.url;
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMorePages) {
          setState(() {
            page++;
            fetchPosts();
          });
        }
      });
    _callUser();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    if (_isLoading || !_hasMorePages) return;

    _isLoading = true;
    filters['page'] = page.toString();

    final postCommand = PostCommandIndex(PostIndex(), filters);

    try {
      var response = await postCommand.execute();

      if (response is  PostModels.PostsModel) {
        setState(() {
          posts.addAll(response.results.data);
          _hasMorePages = response.next != null && response.next!.isNotEmpty;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error',
            message: response is InternalServerError ? 'Error de servidor' : 'Error de conexión',
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
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _reloadPosts() async {
    setState(() {
      page = 1;  // Reiniciar la página
      posts.clear();  // Limpiar la lista de publicaciones
      _hasMorePages = true;  // Permitir más páginas
    });
    await fetchPosts();  // Recargar los datos
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void reloadView() {
    _callUser();
  }

  String _formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('d \'de\' MMMM \'de\' yyyy', 'es_ES');
    return formatter.format(dateTime);
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
              Text(
                name ?? '...',
                style: const TextStyle(
                  fontSize: AppFond.title,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
        actions: [
          SettingsMenu(
            onEditProfile: () async {
              await Navigator.pushNamed(context, 'edit-profile');
              reloadView();
            },
            onLogout: () async {
              if (!_submitting) {
                await _logout(context);
              }
            },
            isEnabled: !_submitting, // Pasar el estado
          ),
        ],
      ),
      body: CustomRefreshIndicator(
        onRefresh: _reloadPosts,  // Función para recargar publicaciones
        child: ListView.builder(
          controller: _scrollController,  // Asignar el ScrollController
          itemCount: posts.length + 1,  // +1 para incluir el encabezado del perfil
          itemBuilder: (context, index) {
            if (index == 0) {
              // Mostrar el encabezado del perfil
              return Padding(
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
                          imageProvider: _coverPhotoUrl != null
                              ? NetworkImage(_coverPhotoUrl!)
                              : null,
                          onPressed: () {
                            if (_coverPhotoUrl != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImage(
                                    imageUrl: _coverPhotoUrl!,
                                  ),
                                ),
                              );
                            }
                          },
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
                                imageProvider: (_profileAvatarUrl != null
                                    ? NetworkImage(_profileAvatarUrl!)
                                    : null),
                                onPressed: () {
                                  if (_profileAvatarUrl != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FullScreenImage(
                                          imageUrl: _profileAvatarUrl!,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '@${username ?? '...'}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: biography?.isNotEmpty ?? false,
                          child: Text(
                            biography ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LabelAction(
                              text: createdAt != null
                                  ? 'Se unió el ${_formatDate(createdAt!)}'
                                  : '...',
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.black,
                              ),
                              icon: Icons.date_range,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${following ?? '0'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                            LabelAction(
                              text: 'Siguiendo',
                              onPressed: () {},
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.inputDark,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              '${followers ?? '0'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                            LabelAction(
                              text: 'Seguidores',
                              onPressed: () {},
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.inputDark,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20), // Ajusta el espacio si es necesario
                      ],
                    ),
                  ],
                ),
              );
            } else {
              final post = posts[index - 1];  // Ajustar índice para los posts
              return PostWidget(
                nameUser: post.relationships.user.name,
                usernameUser: post.relationships.user.username,
                profilePhotoUser: post.relationships.user.profilePhotoUrl ?? '',
                body: post.attributes.body,
                mediaUrl: post.relationships.files.firstOrNull?.attributes.url,
                createdAt: post.attributes.createdAt,
                reactionsCount: post.relationships.reactionsCount.toString(),
                commentsCount: post.relationships.commentsCount.toString(),
                sharesCount: post.relationships.sharesCount.toString(),
              );
            }
          },
        ),
      ),
    );
  }
}
