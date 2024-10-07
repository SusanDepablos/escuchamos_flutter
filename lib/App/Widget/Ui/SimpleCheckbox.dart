import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class SimpleCheckbox extends StatefulWidget {
  final Function(bool) onChanged;
  final String label;
  final Color labelColor;
  final Color checkboxColor; // Color de la caja del checkbox
  final Color checkColor; // Color del check dentro de la caja
  final VoidCallback? onLabelTap;
  final String? error;

  SimpleCheckbox({
    required this.onChanged,
    required this.label,
    this.labelColor = AppColors.black,
    this.checkboxColor = AppColors.primaryBlue, // Valor por defecto
    this.checkColor = AppColors.whiteapp, // Valor por defecto
    this.onLabelTap,
    this.error,
  });

  @override
  _SimpleCheckboxState createState() => _SimpleCheckboxState();
}

class _SimpleCheckboxState extends State<SimpleCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: widget.onLabelTap,
              child: Text(
                widget.label,
                style: TextStyle(
                  color: widget.labelColor,
                  fontSize: 15, // Tamaño de fuente por defecto
                ),
              ),
            ),
            Spacer(), // Este widget expande el espacio entre el label y el checkbox
            Checkbox(
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value ?? false;
                });
                widget.onChanged(_isChecked);
              },
              activeColor: widget.checkboxColor, // Color de la caja cuando está marcada
              checkColor: widget.checkColor, // Color del check dentro de la caja
            ),
          ],
        ),
        if (widget.error != null)
        Text(
          widget.error!,
          style: const TextStyle(
            color: AppColors.errorRed,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
