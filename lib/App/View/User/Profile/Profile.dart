import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/FloatingCircle.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
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
import 'package:escuchamos_flutter/Api/Command/FollowCommand.dart';
import 'package:escuchamos_flutter/Api/Service/FollowService.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/App/View/User/Profile/NavigatorUser.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingBasic.dart';

class Profile extends StatefulWidget {
  final int userId;
  final bool showShares;
  Profile({required this.showShares, required this.userId});

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
  int? _storedUserId;
  bool isFollowing = false;
  bool _loadingFollow = true; // Inicialmente cargando
  int? groupId;
  bool isVerified = false;

  // Obtener el userId desde el almacenamiento seguro
  Future<void> _getStoredUserId() async {
    final user = await _storage.read(key: 'user') ?? '0';
    setState(() {
      _storedUserId = int.parse(user); // Asignar el valor del userId almacenado
    });
  }

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
          builder: (context) => AutoClosePopup(
            child: const LogoutAnimationWidget(), // Aquí se pasa la animación
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
    final userCommand = UserCommandShow(UserShow(), widget.userId);
    try {
      final response = await userCommand.execute();

      if (mounted) {
        if (response is UserModels.UserModel) {
          setState(() {
            _user = response;
            name = _user!.data.attributes.name;
            username = _user!.data.attributes.username;
            biography = _user!.data.attributes.biography;
            followers = _user!.data.relationships.followersCount;
            following = _user!.data.relationships.followingCount;
            createdAt = _user!.data.attributes.createdAt;
            _profileAvatarUrl = _getFileUrlByType('profile');
            _coverPhotoUrl = _getFileUrlByType('cover');

            groupId = _user!.data.relationships.groups[0].id;
            isVerified = groupId == 1 || groupId == 2;

            final followersList = _user!.data.relationships.followers;
            isFollowing = followersList.any((follower) =>
                follower.attributes.followingUser.id == _storedUserId);
            _loadingFollow = false;
            // Puedes usar `isFollowing` para actualizar la UI si es necesario
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
    _callUser();
    _getStoredUserId();
  }

  void reloadView() {
    _callUser();
  }

  String _formatDate(DateTime dateTime) {
    final DateFormat formatter =
        DateFormat('d \'de\' MMMM \'de\' yyyy', 'es_ES');
    return formatter.format(dateTime);
  }

  Future<void> _postFollow() async {
    setState(() {
      _submitting = true;
    });

    try {
      var response = await FollowCommandPost(FollowPost()).execute(
        widget.userId,
      );

      if (response is SuccessResponse) {
        // await showDialog(
        //   context: context,
        //   builder: (context) => PopupWindow(
        //     title: 'Éxito',
        //     message: response.message,
        //   ),
        // );
        // Actualizar el estado para reflejar los cambios en la interfaz
        setState(() {
          isFollowing = !isFollowing; // Alternar entre seguir y dejar de seguir
          if (isFollowing) {
            followers =
                (followers ?? 0) + 1; // Incrementar el número de seguidores
          } else {
            followers =
                (followers ?? 0) - 1; // Decrementar el número de seguidores
          }
        });
      } else {
        await showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title:
                response is InternalServerError ? 'Error' : 'Error de Conexión',
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
    Widget? floatingButton;
    if (_storedUserId != null && _storedUserId == widget.userId) {
      floatingButton = FloatingAddButton(
        onTap: () {
          // Navegar a la vista usando el nombre de la ruta
          Navigator.pushNamed(context, 'new-post'); // Reemplaza 'home' con el nombre de tu ruta
        },
      );
    }
    return Scaffold(
        backgroundColor: AppColors.whiteapp,
        appBar: AppBar(
          backgroundColor: AppColors.whiteapp,
          centerTitle: true,
          title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Asegura que el Row esté centrado
                  children: [
                    Text(
                      username ?? '...',
                      style: const TextStyle(
                        fontSize: AppFond.title,
                        fontWeight: FontWeight.w800,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: 4), // Espaciado entre el texto y el ícono
                    if (isVerified)
                      const Icon(
                        CupertinoIcons.checkmark_seal_fill, // Cambia este ícono según tus necesidades
                        color: AppColors.primaryBlue, // Color del ícono
                        size: 16, // Tamaño del ícono
                      ),
                  ],
                ),
              ],
          ),
          actions: [
            if (_storedUserId != null && _storedUserId == widget.userId) // Validación del userId
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
        body: CustomScrollView(
          slivers: [
            // Sección de historias
            SliverToBoxAdapter(
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
                            '${name ?? '...'}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                            height:
                                8), // Espaciado entre el username y el label
                        if (_storedUserId != null &&
                            _storedUserId != widget.userId)
                          Align(
                            alignment: Alignment.center,
                            child: _loadingFollow
                                ? CustomLoadingIndicator(
                                    color: AppColors.primaryBlue,
                                    size:
                                        20) // Muestra el indicador circular cuando está cargando
                                : GenericButton(
                                    label: isFollowing ? 'Siguiendo' : 'Seguir',
                                    onPressed: _postFollow,
                                    isLoading: _submitting,
                                    width: 120, // Ancho personalizado
                                    height: 40, // Alto personalizado
                                    color: isFollowing
                                        ? AppColors.inputDark
                                        : AppColors.primaryBlue,
                                  ),
                          ),
                        if (_storedUserId != null &&
                            _storedUserId != widget.userId)
                          const SizedBox(height: 8),
                        Visibility(
                          visible: biography?.isNotEmpty ?? false, // Muestra el texto solo si biography no es nulo y no está vacío.
                          child: Container(
                            width: double.infinity, // Hace que el Container ocupe todo el ancho disponible.
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0), // Agrega un padding de 16 píxeles a los lados.
                              child: Text(
                                biography ?? '', // Muestra la biografía si existe, de lo contrario muestra una cadena vacía.
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.black,
                                ),
                                textAlign: TextAlign.justify, // Justifica el texto para que ocupe todo el ancho disponible.
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LabelAction(
                              text: createdAt != null
                                  ? 'Se unió el ${_formatDate(createdAt!)}'
                                  : '...',
                              style: const TextStyle(
                                fontSize: 13.5,
                                color: AppColors.black,
                              ),
                              icon: MaterialIcons.date,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${followers ?? '0'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(width: 4),
                            LabelAction(
                              text: 'Seguidores',
                              onPressed: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  'navigator-follow',
                                  arguments: {
                                    'userId': widget.userId,
                                    'initialTab':
                                    'follower', // Reemplaza con el ID del usuario seguido
                                  },
                                );

                                reloadView();
                              },
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.inputDark,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              '${following ?? '0'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(width: 4),
                            LabelAction(
                              text: 'Seguidos',
                              onPressed: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  'navigator-follow',
                                  arguments: {
                                    'userId': widget.userId,
                                    'initialTab':
                                        'followed', // Reemplaza con el ID del usuario seguido
                                  },
                                );
                                reloadView();
                              },
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.inputDark,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: NavigatorUser(
                initialTab: widget.showShares ? 'shares' : 'posts', // Muestra 'shares' o 'posts' según la condición
                userId: widget.userId,
              ),
            ),
          ],
        ),
      floatingActionButton: floatingButton, // Asigna el botón aquí
    );     
  }
}
