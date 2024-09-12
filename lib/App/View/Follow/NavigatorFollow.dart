import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/View/Follow/SearchFollowers.dart';
import 'package:escuchamos_flutter/App/View/Follow/SearchFollowed.dart';

class NavigatorFollow extends StatefulWidget {
  final String initialTab; // Solo el parámetro requerido
  final String userId; // ID del usuario que se usará en la vista

  NavigatorFollow({required this.initialTab, required this.userId});

  @override
  _NavigatorFollowState createState() => _NavigatorFollowState();
}

class _NavigatorFollowState extends State<NavigatorFollow> {
  late int _initialIndex;

  @override
  void initState() {
    super.initState();
    // Determina el índice inicial basado en el parámetro `initialTab`
    if (widget.initialTab == 'follower') {
      _initialIndex = 0;
    } else if (widget.initialTab == 'followed') {
      _initialIndex = 1;
    } else {
      _initialIndex = 0; // Valor predeterminado si no coincide con ningún caso
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de tabs
      initialIndex: _initialIndex, // Establece el índice inicial
      child: Scaffold(
        appBar: AppBar(
          title: Text('Navegador de Seguidores'), // Título del AppBar
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight), // Ajusta la altura del AppBar
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
            SearchFollowers(followedUserId: widget.userId),
            SearchFollowed(followingUserId: widget.userId),
          ],
        ),
      ),
    );
  }
}
