import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loadings/LoadingBasic.dart';
class LabelAction extends StatefulWidget {
  final String? text;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final bool isLoading;
  final IconData? icon; // Campo opcional para el ícono
  final double? iconSize; // Campo opcional para el tamaño del ícono
  final EdgeInsetsGeometry? padding; // Campo opcional para padding

  LabelAction({
    this.text,
    this.onPressed,
    this.style,
    this.isLoading = false,
    this.icon, // Inicialización del campo opcional para el ícono
    this.iconSize = 24, // Valor por defecto para el tamaño del ícono
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Valor por defecto
  });

  @override
  _LabelActionState createState() => _LabelActionState();
}

class _LabelActionState extends State<LabelAction> {
  void _handlePress() {
    if (!widget.isLoading) {
      widget.onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handlePress,
      child: Container(
        padding: widget.padding,
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
            // Texto e ícono visible cuando isLoading es false
            Visibility(
              visible: !widget.isLoading,
              child: Row(
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: widget.iconSize, color: widget.style?.color ?? AppColors.black),
                    SizedBox(width: 8), // Espacio entre el ícono y el texto
                  ],
                  if (widget.text != null)
                    Text(
                      widget.text!,
                      style: widget.style ??
                          TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 16, // Tamaño de fuente por defecto
                          ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LabelActionWithDisable extends StatefulWidget {
  final String? text;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final bool isLoading;
  final EdgeInsetsGeometry? padding; // Campo opcional para padding

  LabelActionWithDisable({
    this.text,
    this.onPressed,
    this.style,
    this.isLoading = false,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Valor por defecto
  });

  @override
  _LabelActionWithDisableState createState() => _LabelActionWithDisableState();
}

class _LabelActionWithDisableState extends State<LabelActionWithDisable> {
  bool _isDisabled = false;

  void _handlePress() {
    if (!_isDisabled && !widget.isLoading) {
      widget.onPressed?.call();

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
        padding: widget.padding,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Indicador de carga visible cuando isLoading es true
            Visibility(
              visible: widget.isLoading,
              child: SizedBox(
                width: 16, // Ancho del indicador de carga
                height: 16, // Alto del indicador de carga
                child: CustomLoadingIndicator(
                  color: AppColors.primaryBlue
                ),
              ),
            ),
            // Texto visible cuando isLoading es false
            Visibility(
              visible: !widget.isLoading,
              child: Text(
                widget.text!,
                style: widget.style ??
                    TextStyle(
                      color: _isDisabled ? AppColors.inputDark : AppColors.primaryBlue,
                      fontSize: 16, // Tamaño de fuente por defecto
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

