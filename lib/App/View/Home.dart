import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/View/User/Profile/NavigatorUser.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Histories/HistoryListView.dart'; // Actualiza con la ruta correcta

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteapp,
      body: CustomScrollView(
        slivers: [
          // Sección de historias
          SliverToBoxAdapter(
            child: Container(
              height: 100, // Ajusta la altura según lo necesites
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  HistoryList(
                    imageUrl: 'https://example.com/profile1.jpg',
                    userName: 'User1',
                  ),
                  HistoryList(
                    imageUrl: 'https://example.com/profile2.jpg',
                    userName: 'User2',
                  ),
                  HistoryList(
                    imageUrl: 'https://example.com/profile3.jpg',
                    userName: 'User3',
                  ),
                ],
              ),
            ),
          ),
          // Espacio para el contenido principal
          SliverFillRemaining(
            child: NavigatorUser(
              initialTab: 'posts', // O 'shares', según la lógica que necesites
            ),
          ),
        ],
      ),
    );
  }
}
