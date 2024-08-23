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
      // 1) AppBar
      appBar: AppBar(
        title: Text('Base Navigator'),
      ),
      
      // 2) Body: cambia dependiendo del BottomNavigationBar
      body: _user.isEmpty && _groups.isEmpty
          ? Center(child: CircularProgressIndicator()) // Mostrar un indicador de carga mientras se obtienen los datos
          : _views[_currentIndex], // Mostrar la vista basada en _currentIndex
      
      // 3) BottomNavigationBar
    bottomNavigationBar: Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Espaciado en los laterales y en la parte inferior
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco para el contenedor
        borderRadius: BorderRadius.all(Radius.circular(50)), // Bordes redondeados en todas las esquinas
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Color de la sombra con opacidad
            spreadRadius: 1, // Radio de propagación de la sombra
            blurRadius: 10, // Radio de desenfoque de la sombra
            offset: Offset(0, 4), // Desplazamiento de la sombra (hacia abajo)
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // Actualizar _currentIndex para mostrar la vista correspondiente
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 28), // Icono de estilo más ligero
            activeIcon: Icon(Icons.home, size: 28), // Icono activo con relleno
            label: '', // Etiqueta vacía
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined, size: 28), // Icono de estilo más ligero
            activeIcon: Icon(Icons.search, size: 28), // Icono activo con relleno
            label: '', // Etiqueta vacía
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 28), // Icono de estilo más ligero
            activeIcon: Icon(Icons.person, size: 28), // Icono activo con relleno
            label: '', // Etiqueta vacía
          ),
        ],
        backgroundColor: Colors.transparent, // Fondo transparente para el BottomNavigationBar
        selectedItemColor: AppColors.primaryBlue, // Color del icono seleccionado
        unselectedItemColor: Colors.grey, // Color del icono no seleccionado
        showUnselectedLabels: false, // Ocultar etiquetas no seleccionadas
        type: BottomNavigationBarType.fixed, // Asegura que todos los iconos y textos se mantengan visibles
        elevation: 0, // Elevación en el BottomNavigationBar en sí
        iconSize: 28, // Tamaño del icono
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // Estilo de texto seleccionado (sin efecto con etiquetas vacías)
      ),
    ),
    );
  }
}
