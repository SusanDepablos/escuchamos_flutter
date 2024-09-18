import 'package:escuchamos_flutter/App/View/Post/NewPost.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart'; // Asegúrate de que los colores estén definidos en este archivo
import 'package:escuchamos_flutter/App/View/Post/Index.dart'; // Asegúrate de tener esta vista
// import 'package:escuchamos_flutter/App/View/Post/Stories.dart'; // Asegúrate de tener esta vista

class NavigatorPost extends StatefulWidget {
  final String initialTab; // Solo el parámetro requerido

  NavigatorPost({required this.initialTab});

  @override
  _NavigatorPostState createState() => _NavigatorPostState();
}

class _NavigatorPostState extends State<NavigatorPost> {
  late int _initialIndex;

  @override
  void initState() {
    super.initState();
    // Determina el índice inicial basado en el parámetro `initialTab`
    if (widget.initialTab == 'posts') {
      _initialIndex = 0;
    } else if (widget.initialTab == 'stories') {
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
        body: Column(
          children: [
            Container(
              color: AppColors.whiteapp, // Fondo blanco
              child: TabBar(
                labelColor: AppColors.primaryBlue, // Color del texto de la pestaña seleccionada
                unselectedLabelColor: AppColors.black, // Color del texto de las pestañas no seleccionadas
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: AppColors.primaryBlue, // Color de la línea de la pestaña seleccionada
                    width: 3.0, // Ancho de la línea
                  ),
                  insets: EdgeInsets.symmetric(horizontal: 16.0), // Espaciado alrededor de la línea
                ),
                tabs: [
                  Tab(text: 'Nueva Publicación'),
                  Tab(text: 'Nueva Historia'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  const Center(child: Text('Nueva Publiación')),
                  const Center(child: Text('Nueva historia')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
