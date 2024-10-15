import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/View/User/Profile/NavigatorUser.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Story/StoryListView.dart'; // Actualiza con la ruta correcta

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
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  StoryList(
                    imageUrl: 'https://asociacioncivilescuchamos.onrender.com/media/photos_user/735d91fb-e21a-4838-9975-ad8213867af7.jpg',
                    username: 'isabella.ladera',
                    showAddIcon: true,
                    isGradientBorder : false,
                    showBorder: false,
                  ),
                  StoryList(
                    imageUrl: 'https://asociacioncivilescuchamos.onrender.com/media/photos_user/735d91fb-e21a-4838-9975-ad8213867af7.jpg',
                    username: 'juan.pablo',
                  ),
                  StoryList(
                    imageUrl: 'https://asociacioncivilescuchamos.onrender.com/media/photos_user/735d91fb-e21a-4838-9975-ad8213867af7.jpg',
                    username: 'beele',
                  ),
                  StoryList(
                    imageUrl: 'https://asociacioncivilescuchamos.onrender.com/media/photos_user/735d91fb-e21a-4838-9975-ad8213867af7.jpg',
                    username: 'susan.depablos.official',
                  ),
                  StoryList(
                    imageUrl: 'https://asociacioncivilescuchamos.onrender.com/media/photos_user/735d91fb-e21a-4838-9975-ad8213867af7.jpg',
                    username: 'escuchamos',
                  ),
                  // Agrega más StoryList según sea necesario...
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
