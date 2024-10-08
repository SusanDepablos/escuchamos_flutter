import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class DigitBox extends StatelessWidget {
  final TextEditingController input;
  final Color focusedBorderColor;
  final Color digitTextColor;
  final Color boxColor;
  final String? error;

  DigitBox({
    required this.input,
    this.focusedBorderColor = AppColors.inputBasic,
    this.digitTextColor = AppColors.black,
    this.boxColor = AppColors.whiteapp,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            child: TextField(
              controller: input,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: digitTextColor,
                fontSize: 24.0, // Tamaño de fuente
              ),
              decoration: InputDecoration(
                hintText: 'Introduce el código', // Placeholder ajustado
                hintStyle: const TextStyle(
                  color: AppColors.grey, // Color del placeholder
                  fontSize: 20.0, // Tamaño del texto del placeholder
                ),
                counterText: "", // Ocultar contador
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0), // Bordes redondeados de 4
                  borderSide: BorderSide(color: focusedBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0), // Bordes redondeados de 4
                  borderSide: BorderSide(color: focusedBorderColor),
                ),
                fillColor: boxColor,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0), // Ajustar la altura
              ),
              onChanged: (value) {
                // Limitar la entrada a solo números
                if (value.isNotEmpty && !RegExp(r'^\d+$').hasMatch(value)) {
                  input.text = value.substring(0, value.length - 1);
                  input.selection = TextSelection.fromPosition(
                      TextPosition(offset: input.text.length));
                }
              },
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              error!,
              style: TextStyle(color: AppColors.errorRed, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
