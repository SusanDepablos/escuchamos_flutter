import 'package:escuchamos_flutter/App/View/EscuChamos/Index.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async'; // Importa esto
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/App/View/Home.dart';
import 'package:escuchamos_flutter/App/View/SearchUser.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Logo.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/CustomDrawer.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart'; 
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/App/View/Post/NewPost.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingBasic.dart';

class BaseNavigator extends StatefulWidget {
  @override
  _BaseNavigatorState createState() => _BaseNavigatorState();
}

class _BaseNavigatorState extends State<BaseNavigator> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  List<dynamic> _groups = [];
  UserModel? _user;
  int _id = 0;
  String? name;
  String? username;
  int? followers;
  int? following;
  bool _isGroupOne = false;
  bool _isGroupTwo = false;
  bool _isBottomNavVisible = true;
  bool _isAppBarVisible = true;
  Timer? _scrollTimer; // Timer para rastrear la actividad de scroll

  Future<void> _initializeData() async {
    await _callUser();
    await _getData();
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void reloadView() {
    _initializeData();
  }

  Future<void> _getData() async {
      final id = await _storage.read(key: 'user') ?? '';
      final groupsString = await _storage.read(key: 'groups') ?? '[]';
      final groups = (groupsString.isNotEmpty)
        ? List<dynamic>.from(json.decode(groupsString))
        : [];

      setState(() {
        _id = int.parse(id);
        _groups = groups;
        if (groups.contains(1)) {
          _isGroupOne = true;
        } else if (groups.contains(2)) {
          _isGroupTwo = true;
        }
      });
    }

  Future<void> _callUser() async {

    final id = await _storage.read(key: 'user') ?? '';
    final userCommand = UserCommandShow(UserShow(), int.parse(id));

    try {
      final response = await userCommand.execute();

      if (mounted) {
        if (response is UserModel) {
          await _storage.delete(key: 'groups');
          setState(() {
            _user = response;
            name = _user!.data.attributes.name;
            username = _user!.data.attributes.username;
            followers = _user!.data.relationships.followersCount;
            following = _user!.data.relationships.followingCount;
          });
          final groupId = _user!.data.relationships.groups[0].id;
          List<int> group = [groupId];
          await _storage.write(key: 'groups', value: json.encode(group));

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

  final List<Widget> _views = [
    Home(), 
    SearchView(), 
    NewPost(),
    const Center(child: Text('notificaciones')),
    IndexEscuChamos(),
  ];

  void _onScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.scrollDelta! > 0 && _isBottomNavVisible) {
        // Si estás haciendo scroll hacia abajo y el nav es visible
        setState(() {
          _isBottomNavVisible = false;
        });
      } else if (notification.scrollDelta! < 0 && !_isBottomNavVisible) {
        // Si estás haciendo scroll hacia arriba y el nav es invisible
        setState(() {
          _isBottomNavVisible = true;
        });
      }

      // Reinicia el temporizador en cada actualización de scroll
      _resetScrollTimer();
    }
  }

  void _resetScrollTimer() {
    // Cancela el temporizador anterior si existe
    _scrollTimer?.cancel();

    // Inicia un nuevo temporizador de 2 segundos
    _scrollTimer = Timer(const Duration(seconds: 1), () {
      if (!_isBottomNavVisible) {
        setState(() {
          _isBottomNavVisible = true; // Muestra el nav después de 2 segundos
        });
      }
    });
  }

  @override
  void dispose() {
    // Asegúrate de cancelar el temporizador cuando el widget se destruya
    _scrollTimer?.cancel();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
      // Cambiar la visibilidad del AppBar según el índice seleccionado
      _isAppBarVisible = index != 2; // Supongamos que 2 es el índice de NewPostView
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? profileAvatarUrl = _getFileUrlByType('profile');
    ImageProvider? imageProvider;

    if (profileAvatarUrl != null && profileAvatarUrl.isNotEmpty) {
      imageProvider = NetworkImage(profileAvatarUrl);
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.whiteapp,
      appBar: _isAppBarVisible
          ? AppBar(
        backgroundColor: AppColors.whiteapp,
        elevation: 0,
        leading: ProfileAvatar(
          avatarSize: 30.0,
          iconSize: 15.0,
          imageProvider: imageProvider,
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
            reloadView();
          },
        ),
        title: Row(
          children: [
            Center(
              child: LogoBanner(),
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: kToolbarHeight,
      ): null,
      drawer: CustomDrawer(
        name: name,
        username: username,
        followers: followers ?? 0,
        following: following ?? 0,
        imageProvider: imageProvider,
        onProfileTap: () async {
          if (_id != 0) {
            final userId = _id; // Convierte el ID a int si es necesario
            await Navigator.pushNamed(
              context, 
              'profile', 
              arguments: {'showShares': false, 'userId': userId}, // Pasa el ID como argumento
            );
            reloadView();
          }
        },

        onSettingsTap: () async {
          final result = await Navigator.pushNamed(context, 'settings');
          reloadView();
        },
        onAboutTap: () async {
          final result = await Navigator.pushNamed(context, 'about');
          reloadView();
        },

        onFollowedTap: () async {
          final result = await Navigator.pushNamed(
            context,
            'navigator-follow',
              arguments: {
                'userId': _id,
                'initialTab': 'followed', // Reemplaza con el ID del usuario seguido
              },
          );

          reloadView();
        },

        onFollowersTap: () async {
          final result = await Navigator.pushNamed(
            context,
            'navigator-follow',
            arguments: {
              'userId': _id,
              'initialTab': 'follower', // Reemplaza con el ID del usuario seguido
            },
          );

          reloadView();
        },

        showContentModeration: _isGroupOne || _isGroupTwo,

        onContentModerationTap: () async {
          if (_isGroupOne || _isGroupTwo) {
            await Navigator.pushNamed(context, 'content-moderation');
          }
        },

        showAdminUser: _isGroupOne,

        onAdminUserTap: () async {
          if (_isGroupOne || _isGroupTwo) {
            await Navigator.pushNamed(context, 'manage-users-view');
          }
        },
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          _onScroll(notification);
          return true;
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: _id != 0 && _groups.isEmpty
                  ? Center(child: CustomLoadingIndicator(color: AppColors.primaryBlue))
                  : _views[_currentIndex],
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: 16,
              right: 16,
              bottom: _isBottomNavVisible ? 8 : -80, // Ajusta según el tamaño del BottomNavigationBar
              child: AnimatedScale(
                scale: _isBottomNavVisible ? 1.0 : 0.8, // Escala cuando está visible y cuando está oculto
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteapp,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  
                  child: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (int index) {
                      _onBottomNavTap(index); // Cambia aquí
                    },
                    items: [
                      const BottomNavigationBarItem(
                        icon: Icon(MaterialIcons.homeOutlined, size: 28),
                        activeIcon: Icon(MaterialIcons.home, size: 28),
                        label: '',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(MaterialIcons.searchOutlined, size: 28),
                        activeIcon: Icon(MaterialIcons.search, size: 28),
                        label: '',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(MaterialIcons.addCircleOutline, size: 34),
                        activeIcon: Icon(MaterialIcons.addCircle, size: 39),
                        label: '',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(MaterialIcons.notificationsOutlined, size: 28),
                        activeIcon: Icon(MaterialIcons.notifications, size: 28),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Image.asset(
                          'assets/settings_inactive.png',
                          width: 32,
                          height: 32,
                        ),
                        activeIcon: Image.asset(
                          'assets/settings_active.png',
                          width: 34,
                          height: 34,
                        ),
                        label: '',
                      ),
                    ],
                    backgroundColor: Colors.transparent,
                    selectedItemColor: AppColors.primaryBlue,
                    unselectedItemColor: AppColors.inputDark,
                    showUnselectedLabels: false,
                    type: BottomNavigationBarType.fixed,
                    elevation: 0,
                    iconSize: 28,
                    selectedLabelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
