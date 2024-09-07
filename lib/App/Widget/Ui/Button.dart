import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class GenericButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? color; // Nuevo parámetro para color

  GenericButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.color, // Inicialización del nuevo parámetro
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primaryBlue, // Usa el color proporcionado o el predeterminado
        foregroundColor: Colors.white, // Color del texto blanco
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        minimumSize: Size(double.infinity, 50), // Tamaño mínimo constante
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Indicador de carga visible cuando isLoading es true
          Visibility(
            visible: isLoading,
            child: SizedBox(
              width: 24, // Ancho del indicador de carga
              height: 24, // Alto del indicador de carga
              child: CircularProgressIndicator(
                color: Colors.white, // Color del indicador
                strokeWidth: 2, // Grosor del indicador
              ),
            ),
          ),
          // Texto visible cuando isLoading es false
          Visibility(
            visible: !isLoading,
            child: Text(
              label,
              style: TextStyle(fontSize: 16), // Ajusta el tamaño del texto si es necesario
            ),
          ),
        ],
      ),
    );
  }
}

class LockableButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool
      isLocked; // Nuevo parámetro para definir el estado bloqueado/desbloqueado
  final Color? color; // Color del botón

  LockableButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isLocked = true, // Por defecto está bloqueado
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading || isLocked
          ? null
          : onPressed, // Deshabilita el botón si está bloqueado o cargando
      style: ElevatedButton.styleFrom(
        backgroundColor: color ??
            AppColors
                .primaryBlue, // Usa el color proporcionado o el predeterminado
        foregroundColor: Colors.white, // Color del texto blanco
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        minimumSize: Size(double.infinity, 50), // Tamaño mínimo constante
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Indicador de carga visible cuando isLoading es true
          Visibility(
            visible: isLoading,
            child: SizedBox(
              width: 24, // Ancho del indicador de carga
              height: 24, // Alto del indicador de carga
              child: CircularProgressIndicator(
                color: Colors.white, // Color del indicador
                strokeWidth: 2, // Grosor del indicador
              ),
            ),
          ),
          // Texto visible cuando isLoading es false
          Visibility(
            visible: !isLoading,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 16), // Ajusta el tamaño del texto si es necesario
            ),
          ),
        ],
      ),
    );
  }
}
