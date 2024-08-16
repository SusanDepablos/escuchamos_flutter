import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/TermsAndConditionsDialog.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class CustomCheckboxListTile extends StatefulWidget {
  @override
  _CustomCheckboxListTileState createState() => _CustomCheckboxListTileState();
}

class _CustomCheckboxListTileState extends State<CustomCheckboxListTile> {
  bool _acceptedTerms = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Padding interno del tile
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          tileColor: Colors.white, // Color de fondo del tile cuando no está seleccionado
          selectedTileColor: Colors.grey[300], // Color de fondo del tile cuando está seleccionado
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Aceptar términos y condiciones',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              Checkbox(
                value: _acceptedTerms,
                onChanged: (newValue) {
                  setState(() {
                    _acceptedTerms = newValue!;
                    _errorMessage = _acceptedTerms ? null : 'Debes aceptar los términos y condiciones';
                  });
                  if (_acceptedTerms) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return TermsAndConditionsDialog(); // Aquí llamamos a la nueva vista de términos y condiciones
                      },
                    );
                  }
                },
                activeColor: AppColors.primaryBlue, // Color del checkbox cuando está seleccionado
                checkColor: Colors.white, // Color del check dentro del checkbox
              ),
            ],
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 8.0),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: AppColors.errorRed, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
