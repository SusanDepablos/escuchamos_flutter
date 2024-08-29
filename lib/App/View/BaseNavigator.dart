import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/App/View/Home.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Logo.dart';
import 'package:escuchamos_flutter/App/Widget/CustomDrawer.dart'; // Importar el widget Drawer
import 'dart:convert';
import 'package:escuchamos_flutter/App/Widget/ProfileAvatar.dart'; 

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
  String _id = '';

  Future<void> _getData() async {
    final id = await _storage.read(key: 'user') ?? '';
    final groupsString = await _storage.read(key: 'groups') ?? '[]';
    final groups = (groupsString.isNotEmpty)
        ? List<dynamic>.from(json.decode(groupsString))
        : [];

    setState(() {
      _id = id;
      _groups = groups;
    });
  }

  final List<material.Widget> _views = [
    Home(), // Vista 0
    Center(child: Text('Search View')),
    Center(child: Text('Profile View')),
  ];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  material.Widget build(BuildContext context) {
    return material.Scaffold(
      key: _scaffoldKey, // Asignar el GlobalKey al Scaffold
        appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: ProfileAvatar(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: LogoBanner(), // Aquí se inserta el LogoBanner en el AppBar
        centerTitle: true, // Para centrar el LogoBanner en el AppBar
      ),

      drawer: CustomDrawer(), // Usar el widget Drawer aquí

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
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                unselectedItemColor: Colors.grey,
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


