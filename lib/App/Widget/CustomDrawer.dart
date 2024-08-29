// lib/App/Widget/Drawer.dart
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/ProfileAvatar.dart'; 

class CustomDrawer extends StatelessWidget {
  final String name;
  final String email;

  CustomDrawer({
    this.name = 'Juan Pérez',
    this.email = 'juan.perez@example.com',
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width *
            0.6, // Ajusta el ancho a un 70% de la pantalla
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(), // Sección del encabezado
            _buildBody(), // Sección del cuerpo
            Expanded(
                child:
                    Container()), // Espacio flexible para empujar el pie hacia abajo
            _buildFooter(), // Sección del pie
          ],
        ),
      ),
    );
  }

Widget _buildHeader() {
    return Column(
      children: [
        Container(
          color: AppColors.whiteapp,
          padding: EdgeInsets.fromLTRB(
              15.0, 30.0, 15.0, 0.0), // Aumenta el padding superior
          height: 176.0, // Mantén la altura en 176.0
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: ProfileAvatar(
                      avatarSize: 60.0, // Tamaño del CircleAvatar
                      iconSize: 30.0,
                    ),
                  ),
                  SizedBox(
                      height: 1), // Espacio entre el CircleAvatar y el nombre
                  Text(
                    'Juan Pérez', // Datos de prueba
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(
                      height:
                          1), // Espacio ajustado entre el nombre y el correo electrónico
                  Text(
                    'juan.perez@example.com', // Datos de prueba
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600, // Negrita básica
                      color: AppColors.inputDark,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(
                      height:
                          10), // Espacio entre el correo electrónico y los nuevos textos
                  Row(
                    children: [
                      Text(
                        '10', // Datos de prueba
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        'siguiendo', // Datos de prueba
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.inputDark,
                        ),
                      ),
                      SizedBox(width: 26),
                      Text(
                        '14', // Datos de prueba
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        'seguidores', // Datos de prueba
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.inputDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                  width:
                      16), // Espacio horizontal entre el Column y el borde derecho del Container
            ],
          ),
        ),
        Container(
          height: 1.0, // Altura de la línea fina
          margin: EdgeInsets.symmetric(
              horizontal: 20.0), // Ajusta el margen horizontal
          decoration: BoxDecoration(
            color: Colors
                .grey[300], // Color de la línea fina (ajusta según el diseño)
            borderRadius: BorderRadius.circular(
                1.0), // Radio pequeño para redondear los extremos
          ),
        ),
      ],
    );
  }




  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.home, color: AppColors.primaryBlue),
            title: Text('Inicio', style: TextStyle(fontSize: 16)),
            onTap: () {
              // Acción al presionar 'Inicio'
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: AppColors.primaryBlue),
            title: Text('Perfil', style: TextStyle(fontSize: 16)),
            onTap: () {
              // Acción al presionar 'Perfil'
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: AppColors.primaryBlue),
            title: Text('Configuración', style: TextStyle(fontSize: 16)),
            onTap: () {
              // Acción al presionar 'Configuración'
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return ListTile(
      leading: Icon(Icons.logout, color: AppColors.errorRed),
      title: Text('Cerrar sesión',
          style: TextStyle(fontSize: 16, color: Colors.red)),
      onTap: () {
        // Acción al presionar 'Cerrar sesión'
      },
    );
  }
}
