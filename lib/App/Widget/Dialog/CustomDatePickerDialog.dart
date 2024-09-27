import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Locale locale;

  CustomDatePickerDialog({
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.locale,
  });

  @override
  _CustomDatePickerDialogState createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.whiteapp,
      title: const Text(
        'Selecciona una fecha',
        style: TextStyle(fontSize: 18),
      ),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: const BoxConstraints(
                maxHeight: 300,
              ),
              child: Builder(
                builder: (BuildContext context) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      primaryColor: AppColors.primaryBlue, // Color de la barra superior (AppBar)
                      colorScheme: const ColorScheme.light(
                        primary: AppColors.primaryBlue, // Color del día seleccionado
                        onPrimary: AppColors.whiteapp, // Color del texto en el día seleccionado
                        onSurface: AppColors.black, // Color del texto en los días no seleccionados
                      ),
                    ),
                    child: CalendarDatePicker(
                      initialDate: widget.initialDate ?? DateTime.now(),
                      firstDate: widget.firstDate,
                      lastDate: widget.lastDate,
                      onDateChanged: (DateTime newDate) {
                        setState(() {
                          _selectedDate = newDate; // Guarda la fecha seleccionada
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el diálogo sin devolver datos
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.black, // Color del texto del botón "Cancelar"
                  ),
                  child: const Text('Cancelar', style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(width: 10), // Espacio entre los botones
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(_selectedDate); // Devuelve la fecha seleccionada
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.black, // Color del texto del botón "Aceptar"
                  ),
                  child: const Text('Aceptar', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 20), // Espacio debajo de los botones
          ],
        ),
      ),
    );
  }
}
