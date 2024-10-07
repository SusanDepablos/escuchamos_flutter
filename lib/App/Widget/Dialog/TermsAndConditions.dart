import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Evita cerrar el diálogo al tocar fuera
      child: AlertDialog(
        backgroundColor: AppColors.whiteapp,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Center(
          child: Text(
            'Términos y Condiciones',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        content: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '1. Aceptación de los Términos\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   Al acceder y utilizar la aplicación móvil EscuChamos ("la Aplicación"), aceptas estos Términos y Condiciones ("Términos"). Si no estás de acuerdo con estos Términos, por favor, no utilices la Aplicación. Nos reservamos el derecho de modificar estos Términos en cualquier momento, por lo que te recomendamos que los revises periódicamente.\n\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text: '2. Uso de la Aplicación\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  TextSpan(
                    text: '   2.1. Registro de Usuario\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   Para acceder a las funciones de la Aplicación, es necesario crear una cuenta. Eres responsable de proporcionar información precisa y actualizada durante el registro y de mantener la confidencialidad de la información de tú cuenta.\n\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text: '   2.2. Responsabilidad del Usuario\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   Eres responsable del uso que hagas de tu cuenta y de todas las actividades que se realicen bajo tu cuenta. Debes notificar inmediatamente a EscuChamos si crees que tu cuenta ha sido comprometida.\n\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text: '3. Contenido del Usuario\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  TextSpan(
                    text: '   3.1. Derechos de Publicación\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   Al publicar contenido en la Aplicación, otorgas a EscuChamos una licencia global, no exclusiva, libre de regalías y sublicenciable para utilizar, reproducir, modificar y mostrar dicho contenido con el fin de operar y mejorar la Aplicación.\n\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text: '   3.2. Contenido Prohibido\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   No debes publicar contenido que sea ilegal, difamatorio, obsceno, amenazante o que infrinja los derechos de terceros. EscuChamos se reserva el derecho de eliminar cualquier contenido que considere inapropiado.\n\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text: '4. Seguridad\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  TextSpan(
                    text: '   4.1. Medidas de Seguridad\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   Implementamos medidas de seguridad para proteger la Aplicación y tu información personal. Sin embargo, no podemos garantizar la seguridad absoluta y no nos hacemos responsables de ningún acceso no autorizado.\n\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text: '   4.2. Actividades Prohibidas\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   Está prohibido intentar obtener acceso no autorizado a la Aplicación, alterar su funcionamiento o comprometer su integridad de cualquier manera.\n\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text: '5. Propiedad Intelectual\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  TextSpan(
                    text: '   5.1. Derechos de Propiedad\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   Todos los derechos de propiedad intelectual relacionados con la Aplicación, incluyendo marcas comerciales, logotipos y contenido, son propiedad de EscuChamos o de sus licenciantes.\n\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text: '   5.2. Uso de la Marca\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   No se permite el uso de las marcas comerciales, logotipos o cualquier otro contenido protegido sin el consentimiento previo y por escrito de EscuChamos.\n\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text: '6. Terminación\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  TextSpan(
                    text: '   6.1. Terminación del Servicio\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text:
                        '   EscuChamos se reserva el derecho de suspender o terminar tu acceso a la Aplicación en cualquier momento, por cualquier motivo, sin previo aviso.\n\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text: '   6.2. Efectos de la Terminación\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' En caso de terminación, se cancelarán tus derechos de uso de la Aplicación y perderás acceso a cualquier contenido que hayas publicado.\n\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text: '7. Ley Aplicable\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' Estos Términos se regirán e interpretarán de acuerdo con las leyes del país en el que se encuentre EscuChamos. Cualquier disputa relacionada con estos Términos se resolverá en los tribunales competentes.\n\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text: '8. Aceptación de los Términos\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' Al utilizar la Aplicación, confirmas que has leído, entendido y aceptado estos Términos y Condiciones.\n',
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 12), // Padding para los botones
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centra los botones
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold, // Texto negro y en negrita
                  ),
                ),
              ),
              const SizedBox(width: 20), // Espacio entre los botones
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                }, // Desactiva el botón si no está habilitado
                child: const Text(
                  'Aceptar',
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold, // Texto negro y en negrita
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
