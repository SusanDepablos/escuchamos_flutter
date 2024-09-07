import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/App/View/Home.dart';
import 'package:escuchamos_flutter/App/View/SearchView.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Logo.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/CustomDrawer.dart'; // Importar el widget Drawer
import 'dart:convert';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart'; 

class BaseNavigator extends material.StatefulWidget {
  @override
  _BaseNavigatorState createState() => _BaseNavigatorState();
}

class _BaseNavigatorState extends material.State<BaseNavigator> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final material.GlobalKey<material.ScaffoldState> _scaffoldKey =
      material.GlobalKey<material.ScaffoldState>();
  int _currentIndex = 0;
  List<dynamic> _groups = [];
  UserModel? _user;
  String _id = '';
  String? name;
  String? username;
  int? followers;
  int? following;
  bool _isGroupOne = false;

  @override
  void initState() {
    super.initState();
    _getData();
    _callUser();
  }

  void reloadView(){
    _callUser();
  }

  Future<void> _getData() async {
    final id = await _storage.read(key: 'user') ?? '';
    final groupsString = await _storage.read(key: 'groups') ?? '[]';
    final groups = (groupsString.isNotEmpty)
        ? List<dynamic>.from(json.decode(groupsString))
        : [];

    setState(() {
      _id = id;
      _groups = groups;
      _isGroupOne = groups.contains(1);
    });
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
            followers = _user!.data.relationships.followersCount;
            following = _user!.data.relationships.followingCount;

          });
        } else {
          showDialog(
            context: context,
            builder: (context) => PopupWindow(
              title: 'Error de Conexión',
              message: 'Error de conexión',
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
            message: 'Error: $e',
          ),
        );
      }
    }
  }

  // Método auxiliar para obtener la URL del archivo por tipo
  String? _getFileUrlByType(String type) {
    try {
      final file = _user?.data.relationships.files.firstWhere(
        (file) => file.attributes.type == type,
      );
      return file?.attributes.url;
    } catch (e) {
      return null; // Retorna null si no se encuentra el archivo
    }
  }

  final List<material.Widget> _views = [
    Home(), // Vista 0
    SearchView(),
    Center(child: Text('Profile View')),
  ];


  @override
  material.Widget build(BuildContext context) {
    // Obtén la URL del avatar si está disponible
    final String? profileAvatarUrl = _getFileUrlByType('profile');
    ImageProvider? imageProvider;

    if (profileAvatarUrl != null && profileAvatarUrl.isNotEmpty) {
      imageProvider = NetworkImage(profileAvatarUrl);
    }
    return material.Scaffold(
      key: _scaffoldKey, // Asignar el GlobalKey al Scaffold
      appBar: AppBar(
        backgroundColor: AppColors.whiteapp,
        elevation: 0,
        leading: ProfileAvatar(
          avatarSize: 30.0,
          iconSize: 15.0,
          imageProvider: imageProvider,
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Row(
          children: [
            Center(
              child: LogoBanner(), // Aquí se inserta el LogoBanner en el AppBar
            ),
          ],
        ),
        centerTitle: true, // Asegúrate de que esta línea esté presente
        toolbarHeight: kToolbarHeight, // Ajusta la altura del AppBar si es necesario
      ),

      drawer: CustomDrawer(
        name: name,
        username: username,
        followers: followers ?? 0,
        following: following ?? 0,
        imageProvider: imageProvider,
        onProfileTap: () async {
          await Navigator.pushNamed(context, 'profile');

          reloadView();
        },
        onContentModerationTap: () async {
          if (_isGroupOne) { // Verificar si el usuario está en el grupo 1 antes de navegar
            await Navigator.pushNamed(context, 'content-moderation');
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
        showContentModeration: _isGroupOne,
      ),
 // Usar el widget Drawer aquí
      body: material.Stack(
        children: [
          material.Positioned.fill(
            child: _id.isEmpty && _groups.isEmpty
                ? Center(child: CircularProgressIndicator())
                : _views[_currentIndex],
          ),

          // BottomNavigationBar flotante
          material.Positioned(
            left: 16,
            right: 16,
            bottom: 8,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteapp,
                borderRadius: BorderRadius.all(Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: material.BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: [
                  material.BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined, size: 28),
                    activeIcon: Icon(Icons.home, size: 28),
                    label: '',
                  ),
                  material.BottomNavigationBarItem(
                    icon: Icon(Icons.search_outlined, size: 28),
                    activeIcon: Icon(Icons.search, size: 28),
                    label: '',
                  ),
                  material.BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline, size: 28),
                    activeIcon: Icon(Icons.person, size: 28),
                    label: '',
                  ),
                ],
                backgroundColor: Colors.transparent,
                selectedItemColor: AppColors.primaryBlue,
                unselectedItemColor: AppColors.inputDark,
                showUnselectedLabels: false,
                type: material.BottomNavigationBarType.fixed,
                elevation: 0,
                iconSize: 28,
                selectedLabelStyle:
                    TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


