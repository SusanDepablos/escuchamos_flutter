import 'package:flutter/material.dart';

class Select extends StatelessWidget {
  final String? selectedValue;
  final List<String?> items;
  final void Function(String?)? onChanged;
  final String hintText;
  final TextStyle? textStyle;
  final Color dropdownColor;
  final double iconSize;

  Select({
    required this.selectedValue,
    required this.items,
    this.onChanged,
    this.hintText = '+0',
    this.textStyle,
    this.dropdownColor = Colors.white,
    this.iconSize = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment:
          Alignment.center, // Alinea el contenido al centro del contenedor
      child: DropdownButton<String?>(
        value: selectedValue,
        hint: Text(
          hintText,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
        items: items
            .map((code) {
              return DropdownMenuItem<String?>(
                value: code,
                child: Text(
                  code ?? '',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              );
            })
            .toSet()
            .toList(),
        onChanged: onChanged,
        style: textStyle,
        dropdownColor: dropdownColor,
        underline: SizedBox(), // Sin subrayado
        icon: SizedBox(), // Sin ícono
        iconSize: iconSize, // Tamaño del ícono
        alignment:
            Alignment.center, // Alinea el contenido del dropdown al centro
      ),
    );
  }
}
