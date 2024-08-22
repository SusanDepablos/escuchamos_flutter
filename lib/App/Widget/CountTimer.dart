import 'package:flutter/material.dart';
import 'dart:async';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class CountTimer extends StatefulWidget {
  final VoidCallback onTimerEnd; // Callback que se ejecutará cuando el tiempo termine

  CountTimer({required this.onTimerEnd});

  @override
  _CountTimerState createState() => _CountTimerState();
}

class _CountTimerState extends State<CountTimer> {
  late Timer _timer;
  int _remainingTime = 180; // 3 minutos en segundos

  @override
  void initState() {
    super.initState();
    _startTimer();
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
          widget.onTimerEnd(); // Llamar al callback cuando el tiempo se agota
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');

    // Cambiar el color del texto basado en el tiempo restante
    final textColor = _remainingTime <= 20 ? AppColors.errorRed : AppColors.primaryBlue;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Text(
        "$minutes:$seconds",
        style: TextStyle(
          fontSize: 16.0, // Tamaño de fuente más grande
          fontWeight: FontWeight.bold,
          color: textColor, // Color del texto basado en el tiempo restante
        ),
      ),
    );
  }
}
