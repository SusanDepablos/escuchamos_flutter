import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class LabelButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? style;
  final bool isLoading;

  LabelButton({
    required this.text,
    required this.onPressed,
    this.style,
    this.isLoading = false,
  });

  @override
  _LabelButtonState createState() => _LabelButtonState();
}

class _LabelButtonState extends State<LabelButton> {
  bool _isDisabled = false;

  void _handlePress() {
    if (!_isDisabled && !widget.isLoading) {
      widget.onPressed();

      // Deshabilitar el botón durante 30 segundos
      setState(() {
        _isDisabled = true;
      });

      // Rehabilitar el botón después de 30 segundos
      Future.delayed(Duration(seconds: 30), () {
        if (mounted) {
          setState(() {
            _isDisabled = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isDisabled ? null : _handlePress,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Indicador de carga visible cuando isLoading es true
            Visibility(
              visible: widget.isLoading,
              child: SizedBox(
                width: 16, // Ancho del indicador de carga
                height: 16, // Alto del indicador de carga
                child: CircularProgressIndicator(
                  strokeWidth: 2, // Grosor del indicador
                ),
              ),
            ),
            // Texto visible cuando isLoading es false
            Visibility(
              visible: !widget.isLoading,
              child: Text(
                widget.text,
                style: widget.style ??
                    TextStyle(
                      color: _isDisabled ? Colors.grey : AppColors.primaryBlue,
                      fontSize: 16, // Tamaño de fuente por defecto
                      decoration: TextDecoration.underline, // Subrayado como un enlace
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
