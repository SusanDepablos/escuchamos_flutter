import 'package:flutter/material.dart';
import 'dart:async';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class CountTimer extends StatefulWidget {
  final VoidCallback
      onTimerEnd; // Callback que se ejecutará cuando el tiempo termine
  final int initialTime; // Tiempo inicial en segundos (opcional)

  // El tiempo predeterminado es de 180 segundos (3 minutos)
  CountTimer({required this.onTimerEnd, this.initialTime = 180});

  @override
  _CountTimerState createState() => _CountTimerState();
}

class _CountTimerState extends State<CountTimer> {
  late Timer _timer;
  late int _remainingTime;
  bool _isVisible = true; // Controla la visibilidad del temporizador

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.initialTime;
    _startTimer();
  }

  @override
  void didUpdateWidget(CountTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si el tiempo inicial cambia, reinicia el temporizador
    if (widget.initialTime != oldWidget.initialTime) {
      _resetTimer(widget.initialTime);
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancelar el temporizador cuando se destruye el widget
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel(); // Detener el temporizador cuando llegue a cero
          _isVisible = false; // Hacer que el temporizador sea invisible
          widget.onTimerEnd(); // Llamar al callback cuando el tiempo se agota
        }
      });
    });
  }

  void _resetTimer(int newTime) {
    // Cancelar el temporizador actual
    _timer.cancel();
    // Establecer el nuevo tiempo
    setState(() {
      _remainingTime = newTime;
      _isVisible = true; // Hacer que el temporizador sea visible nuevamente
    });
    // Volver a iniciar el temporizador
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final String minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final String seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    final Color textColor =
        _remainingTime <= 20 ? AppColors.errorRed : AppColors.primaryBlue;

    return Visibility(
      visible: _isVisible,
      child: Container(
        margin: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 10.0,
        bottom: 10.0,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteapp,
        ),
        child: Text(
          "$minutes:$seconds",
          style: TextStyle(
            fontSize: AppFond.label,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          textScaleFactor: 1.0,
        ),
      ),
    );
  }
}
