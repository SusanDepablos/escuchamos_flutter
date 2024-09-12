import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:async'; // Necesario para el Timer.
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
                child: CustomLoadingIndicator(
                  color: AppColors.primaryBlue
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
  final EdgeInsetsGeometry? padding;

  LabelActionWithDisable({
    this.text,
    this.onPressed,
    this.style,
    this.isLoading = false,
    this.padding = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
  });

  @override
  _LabelActionWithDisableState createState() => _LabelActionWithDisableState();
}

class _LabelActionWithDisableState extends State<LabelActionWithDisable> {
  bool _isDisabled = false;
  int _remainingTime = 30; // Temporizador inicial de 30 segundos.
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel(); // Cancelar el temporizador cuando el widget se destruye.
    super.dispose();
  }

  void _startTimer() {
    // Cancelar el temporizador anterior si existe.
    _timer?.cancel();

    setState(() {
      _remainingTime = 30; // Reiniciar a 30 segundos
      _isDisabled = true;
    });

    // Iniciar el cronómetro que cuenta hacia atrás cada segundo.
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _isDisabled = false; // Habilitar el botón cuando llegue a 0.
          _timer?.cancel(); // Detener el temporizador.
        }
      });
    });
  }

  void _handlePress() {
    if (!_isDisabled && !widget.isLoading) {
      widget.onPressed?.call();
      _startTimer(); // Iniciar el temporizador cuando se presiona el botón.
    }
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');

    return GestureDetector(
      onTap: _isDisabled ? null : _handlePress,
      child: Container(
        padding: widget.padding,
        child: Row(
          children: [
            // Mostrar indicador de carga si está cargando.
            if (widget.isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CustomLoadingIndicator(
                  color: AppColors.primaryBlue
                ),
              ),

            // Mostrar el texto si no está cargando.
            if (!widget.isLoading)
              Text(
                widget.text!,
                style: widget.style ??
                    TextStyle(
                      color: _isDisabled ? AppColors.black : AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
              ),
            SizedBox(width: 10), // Espacio entre el texto y el temporizador.
            // Mostrar el cronómetro solo si el botón está deshabilitado.
            if (_isDisabled)
              Text(
                '$minutes:$seconds', // Formato cronómetro "MM:SS"
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _remainingTime <= 10
                      ? AppColors.errorRed // Cambiar a rojo si quedan 10 segundos o menos.
                      : AppColors.primaryBlue,
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

