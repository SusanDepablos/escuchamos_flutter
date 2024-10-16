import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class GenericButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? color; // Parámetro para color
  final double? width; // Parámetro para el ancho
  final double? height; // Parámetro para el alto
  final double? size; // Parámetro para el alto
  final double? borderRadius; // Nuevo parámetro para el radio de los bordes

  GenericButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.color, // Inicialización del nuevo parámetro
    this.width, // Inicialización del parámetro de ancho
    this.height, // Inicialización del parámetro de alto
    this.size, // Inicialización del parámetro de alto
    this.borderRadius, // Inicialización del nuevo parámetro de radio
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), // Mantiene el tamaño del texto
        child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primaryBlue, // Usa el color proporcionado o el predeterminado
          foregroundColor: Colors.white, // Color del texto blanco
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 15.0), // Bordes redondeados
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          minimumSize: Size(width ?? double.infinity, height ?? 50), // Tamaño mínimo configurable
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Indicador de carga visible cuando isLoading es true
            Visibility(
              visible: isLoading,
              child: const SizedBox(
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
                style: TextStyle(fontSize: size ?? AppFond.subtitle), // Ajusta el tamaño del texto si es necesario
              ),
            ),
          ],
        ),
      )
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), // Mantiene el tamaño del texto
        child: ElevatedButton(
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          minimumSize: const Size(double.infinity, 50), // Tamaño mínimo constante
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Indicador de carga visible cuando isLoading es true
            Visibility(
              visible: isLoading,
              child: const SizedBox(
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
                style: const TextStyle(
                    fontSize: AppFond.subtitle), // Ajusta el tamaño del texto si es necesario
              ),
            ),
          ],
        ),
      )
    );
  }
}
