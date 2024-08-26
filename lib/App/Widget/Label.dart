import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

/// Un widget interactivo que muestra un texto que actúa como un botón con funcionalidad adicional.
class LabelAction extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? style;
  final bool isLoading;

  LabelAction({
    required this.text,
    required this.onPressed,
    this.style,
    this.isLoading = false,
  });

  @override
  _LabelActionState createState() => _LabelActionState();
}

class _LabelActionState extends State<LabelAction> {
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
                      decoration:
                          TextDecoration.underline, // Subrayado como un enlace
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BasicLabel extends StatelessWidget {
  final String name;
  final VoidCallback? onTap;
  final Color color;

  // Constructor del widget Label
  BasicLabel({
    required this.name,
    this.onTap, // onTap es opcional
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Si onTap es null, no hace nada
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

