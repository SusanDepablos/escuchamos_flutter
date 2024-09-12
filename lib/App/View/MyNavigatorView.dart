import 'package:flutter/material.dart';

class MyNavigatorView extends StatefulWidget {
  final String initialTab; // Solo el parámetro requerido

  MyNavigatorView({required this.initialTab});

  @override
  _MyNavigatorViewState createState() => _MyNavigatorViewState();
}

class _MyNavigatorViewState extends State<MyNavigatorView> {
  late int _initialIndex;

  @override
  void initState() {
    super.initState();
    // Determina el índice inicial basado en el parámetro `initialTab`
    _initialIndex = widget.initialTab == 'follower' ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de tabs
      initialIndex: _initialIndex, // Establece el índice inicial
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize:
                Size.fromHeight(kToolbarHeight), // Ajusta la altura del AppBar
            child: TabBar(
              tabs: [
                Tab(text: 'Seguidores'),
                Tab(text: 'Seguidos'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Contenido de Seguidores')),
            Center(child: Text('Contenido de Seguidos')),
          ],
        ),
      ),
    );
  }
}
