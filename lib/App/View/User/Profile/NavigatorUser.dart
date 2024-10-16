import 'package:escuchamos_flutter/App/View/Share/Index.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart'; // Asegúrate de que los colores estén definidos en este archivo
import 'package:escuchamos_flutter/App/View/Post/Index.dart';

class NavigatorUser extends StatefulWidget {
  final String initialTab; // Solo el parámetro requerido
  final int? userId; // ID del usuario que se usará en la vista

  NavigatorUser({required this.initialTab, this.userId});

  @override
  _NavigatorUserState createState() => _NavigatorUserState();
}

class _NavigatorUserState extends State<NavigatorUser> {
  late int _initialIndex;

  @override
  void initState() {
    super.initState();
    // Determina el índice inicial basado en el parámetro `initialTab`
    if (widget.initialTab == 'posts') {
      _initialIndex = 0;
    } else if (widget.initialTab == 'shares') {
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
              child: const TabBar(
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
                  Tab(
                    child: Text(
                      'Publicaciones',
                      style: TextStyle(
                        fontSize: AppFond.subtitle, // Accediendo al tamaño de fuente del estilo
                      ),
                      textScaleFactor: 1.0, // Ajuste de textScaleFactor
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Compartidos',
                      style: TextStyle(
                        fontSize: AppFond.subtitle, // Accediendo al tamaño de fuente del estilo
                      ),
                      textScaleFactor: 1.0, // Ajuste de textScaleFactor
                    ),
                  )
                ]
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  IndexPost(userId: widget.userId),
                  IndexShare(userId: widget.userId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
