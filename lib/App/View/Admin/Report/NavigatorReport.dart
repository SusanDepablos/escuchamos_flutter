import 'package:escuchamos_flutter/App/View/Admin/Report/Index/IndexReportComment.dart';
import 'package:escuchamos_flutter/App/View/Admin/Report/Index/IndexReportPost.dart';
import 'package:escuchamos_flutter/App/View/Admin/Report/Index/IndexReportRepost.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart'; // Asegúrate de que los colores estén definidos en este archivo

class NavigatorReport extends StatefulWidget {
  final String initialTab; // Solo el parámetro requerido
  NavigatorReport({required this.initialTab});

  @override
  _NavigatorReportState createState() => _NavigatorReportState();
}

class _NavigatorReportState extends State<NavigatorReport> {
  late int _initialIndex;

  @override
  void initState() {
    super.initState();
    // Determina el índice inicial basado en el parámetro `initialTab`
    if (widget.initialTab == 'posts') {
      _initialIndex = 0;
    } else if (widget.initialTab == 'reposts') {
      _initialIndex = 1;
    } else if (widget.initialTab == 'comments') {
      _initialIndex = 2;
    } else {
      _initialIndex = 0; // Valor predeterminado si no coincide con ningún caso
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Cambiado a 3 para incluir todas las pestañas
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
                  Tab(text: 'Publicaciones'),
                  Tab(text: 'Repost'),
                  Tab(text: 'Comentarios'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  IndexReportPost(),
                  IndexReportRepost(),
                  IndexReportComment()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
