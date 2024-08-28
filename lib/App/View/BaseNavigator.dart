import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/App/View/Home.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:convert';


class BaseNavigator extends StatefulWidget {
  @override
  _BaseNavigatorState createState() => _BaseNavigatorState();
}

class _BaseNavigatorState extends State<BaseNavigator> {
  final FlutterSecureStorage _storage = FlutterSecureStorage(); // Instancia de FlutterSecureStorage
  int _currentIndex = 0;
  String _user = ''; // Variable de estado para almacenar el usuario
  List<dynamic> _groups = []; // Variable de estado para almacenar los grupos

  // Método para obtener los datos desde FlutterSecureStorage
  Future<void> _getData() async {
    final user = await _storage.read(key: 'user') ?? '';
    final groupsString = await _storage.read(key: 'groups') ?? '[]';
    final groups = (groupsString.isNotEmpty) ? List<dynamic>.from(json.decode(groupsString)) : [];

    setState(() {
      _user = user; // Actualizar el estado con los datos obtenidos
      _groups = groups;
    });
  }

  // Lista de widgets para cada vista que quieras mostrar en el body
  final List<Widget> _views = [
    Home(),    // Vista 0
    Center(child: Text('Search View')),  // Vista 1
    Center(child: Text('Profile View')), // Vista 2
  ];

  @override
  void initState() {
    super.initState();
    _getData(); // Llamar a _getData() al inicializar el estado para cargar los datos
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text('Base Navigator'),
    ),


    // Usar un Stack para superponer el body y el BottomNavigationBar
    body: Stack(
      children: [
        // Body que ocupa toda la pantalla, incluyendo el espacio detrás del BottomNavigationBar
        Positioned.fill(
          child: _user.isEmpty && _groups.isEmpty
              ? Center(child: CircularProgressIndicator())
              : _views[_currentIndex],
        ),

        
        // BottomNavigationBar flotante
        Positioned(
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
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, size: 28),
                  activeIcon: Icon(Icons.home, size: 28),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search_outlined, size: 28),
                  activeIcon: Icon(Icons.search, size: 28),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline, size: 28),
                  activeIcon: Icon(Icons.person, size: 28),
                  label: '',
                ),
              ],
              backgroundColor: Colors.transparent,
              selectedItemColor: AppColors.primaryBlue,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              iconSize: 28,
              selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}

}
