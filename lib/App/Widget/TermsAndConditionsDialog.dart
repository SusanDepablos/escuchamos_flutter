import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class TermsAndConditionsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[100], // Fondo suave
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
      ),
      title: Text(
        'Términos y condiciones',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            '1. Al utilizar esta aplicación, aceptas los siguientes términos y condiciones.\n\n'
            '2. La información proporcionada en esta aplicación es solo para fines informativos.\n\n'
            '3. No nos hacemos responsables de ningún daño o pérdida causados por el uso de esta aplicación.\n\n'
            '4. Nos reservamos el derecho de realizar cambios en los términos y condiciones en cualquier momento sin previo aviso.\n\n'
            '5. Al utilizar esta aplicación, aceptas recibir comunicaciones y notificaciones de nosotros.\n\n'
            '6. El uso indebido de esta aplicación puede resultar en la cancelación de tu cuenta.\n\n'
            '7. Al utilizar esta aplicación, aceptas nuestra política de privacidad.\n\n'
            '8. Si tienes alguna pregunta o inquietud sobre estos términos y condiciones, contáctanos.\n\n'
            '¡Gracias por utilizar nuestra aplicación!',
            style: TextStyle(
              fontSize: 16.0,
              height: 1.5, // Espaciado entre líneas para mejorar la legibilidad
              color: Colors.black54,
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primaryBlue, // Color de fondo del botón
            foregroundColor: Colors.white, // Color del texto del botón
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Bordes redondeados del botón
            ),
          ),
          child: Text(
            'ACEPTAR',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
