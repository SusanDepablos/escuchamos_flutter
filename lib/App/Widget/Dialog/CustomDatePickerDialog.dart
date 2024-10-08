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
  void initState() {
    super.initState();
    // Asegúrate de que la fecha inicial no esté después de lastDate
    if (widget.initialDate != null &&
        widget.initialDate!.isAfter(widget.lastDate)) {
      _selectedDate = widget.lastDate; // Establece la última fecha como la inicial
    } else {
      _selectedDate = widget.initialDate ?? widget.firstDate; // Establece la fecha inicial
    }
  }

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
                      primaryColor: AppColors.primaryBlue,
                      colorScheme: const ColorScheme.light(
                        primary: AppColors.primaryBlue,
                        onPrimary: AppColors.whiteapp,
                        onSurface: AppColors.black,
                      ),
                    ),
                    child: CalendarDatePicker(
                      initialDate: _selectedDate!,
                      firstDate: widget.firstDate,
                      lastDate: widget.lastDate,
                      onDateChanged: (DateTime newDate) {
                        setState(() {
                          _selectedDate = newDate;
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
                    foregroundColor: AppColors.black,
                  ),
                  child: const Text('Cancelar', style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(_selectedDate); // Devuelve la fecha seleccionada
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.black,
                  ),
                  child: const Text('Aceptar', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
