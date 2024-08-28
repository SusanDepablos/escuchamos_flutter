import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/App/View/Home.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Logo.dart';
import 'dart:convert';

class BaseNavigator extends StatefulWidget {
  @override
  _BaseNavigatorState createState() => _BaseNavigatorState();
}

class _BaseNavigatorState extends State<BaseNavigator> {
  final FlutterSecureStorage _storage = FlutterSecureStorage(); // Instancia de FlutterSecureStorage
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // GlobalKey para ScaffoldState
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
      key: _scaffoldKey, // Asignar el GlobalKey al Scaffold
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: Colors.grey[200], // Color de fondo para el avatar
            child: Icon(Icons.person, color: AppColors.inputDark), // Ícono de perfil temporal
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Usar el GlobalKey para abrir el Drawer
          },
        ),
        title: LogoBanner(), // Aquí se inserta el LogoBanner en el AppBar
        centerTitle: true, // Para centrar el LogoBanner en el AppBar
      ),

drawer: Drawer(
  child: Container(
    width: MediaQuery.of(context).size.width * 0.7, // Ajusta el ancho a un 70% de la pantalla
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(
            _user.isNotEmpty ? _user : 'Usuario',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          accountEmail: Text(
            'usuario@example.com',
            style: TextStyle(color: Colors.white70),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: AppColors.primaryBlue, size: 40),
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
          ),
        ),
        ListTile(
          leading: Icon(Icons.home, color: AppColors.primaryBlue),
          title: Text('Inicio', style: TextStyle(fontSize: 16)),
          onTap: () {
            // Acción al presionar 'Inicio'
          },
        ),
        Divider(), // Agrega un divisor para separar los elementos
        ListTile(
          leading: Icon(Icons.person, color: AppColors.primaryBlue),
          title: Text('Perfil', style: TextStyle(fontSize: 16)),
          onTap: () {
            // Acción al presionar 'Perfil'
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings, color: AppColors.primaryBlue),
          title: Text('Configuración', style: TextStyle(fontSize: 16)),
          onTap: () {
            // Acción al presionar 'Configuración'
          },
        ),
        Divider(),
        Spacer(), // Empuja los elementos hacia arriba, dejando 'Cerrar sesión' al final
        ListTile(
          leading: Icon(Icons.logout, color: AppColors.errorRed),
          title: Text('Cerrar sesión', style: TextStyle(fontSize: 16, color: Colors.red)),
          onTap: () {
            // Acción al presionar 'Cerrar sesión'
          },
        ),
      ],
    ),
  ),
),


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
