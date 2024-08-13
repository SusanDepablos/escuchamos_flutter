import 'package:flutter/material.dart';

// Componente de Label que recibe un nombre, una ruta y un color
class Label extends StatelessWidget {
  final String name; // Nombre del Label
  final String route; // Ruta de navegación
  final Color color; // Color del texto

  // Constructor del widget Label
  Label({
    required this.name,
    required this.route,
    this.color = Colors.blue, // Color por defecto
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route); // Navega a la ruta especificada
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 16,
            color: color, // Usa el color especificado
            decoration: TextDecoration.none, // Sin subrayado
          ),
        ),
      ),
    );
  }
}
