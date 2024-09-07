import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // Fondo blanco para un aspecto más limpio
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Bordes más redondeados
      ),
      title: Text(
        'Términos y condiciones',
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '1. Aceptación de los Términos\n'
                      '   Al acceder y utilizar la aplicación móvil EscuChamos ("la Aplicación"), aceptas estos Términos y Condiciones ("Términos"). Si no estás de acuerdo con estos Términos, por favor, no utilices la Aplicación. Nos reservamos el derecho de modificar estos Términos en cualquier momento, por lo que te recomendamos que los revises periódicamente.\n\n'
                      '2. Uso de la Aplicación\n'
                      '   2.1. Registro de Usuario\n'
                      '   Para acceder a algunas funciones de la Aplicación, es necesario crear una cuenta. Eres responsable de proporcionar información precisa y actualizada durante el registro y de mantener la confidencialidad de tu información de cuenta.\n\n'
                      '   2.2. Responsabilidad del Usuario\n'
                      '   Eres responsable del uso que hagas de tu cuenta y de todas las actividades que se realicen bajo tu cuenta. Debes notificar inmediatamente a EscuChamos si crees que tu cuenta ha sido comprometida.\n\n'
                      '3. Contenido del Usuario\n'
                      '   3.1. Derechos de Publicación\n'
                      '   Al publicar contenido en la Aplicación, otorgas a EscuChamos una licencia global, no exclusiva, libre de regalías y sublicenciable para utilizar, reproducir, modificar y mostrar dicho contenido con el fin de operar y mejorar la Aplicación.\n\n'
                      '   3.2. Contenido Prohibido\n'
                      '   No debes publicar contenido que sea ilegal, difamatorio, obsceno, amenazante o que infrinja los derechos de terceros. EscuChamos se reserva el derecho de eliminar cualquier contenido que considere inapropiado.\n\n'
                      '4. Seguridad\n'
                      '   4.1. Medidas de Seguridad\n'
                      '   Implementamos medidas de seguridad para proteger la Aplicación y tu información personal. Sin embargo, no podemos garantizar la seguridad absoluta y no nos hacemos responsables de ningún acceso no autorizado.\n\n'
                      '   4.2. Actividades Prohibidas\n'
                      '   Está prohibido intentar obtener acceso no autorizado a la Aplicación, alterar su funcionamiento o comprometer su integridad de cualquier manera.\n\n'
                      '5. Propiedad Intelectual\n'
                      '   5.1. Derechos de Propiedad\n'
                      '   Todos los derechos de propiedad intelectual relacionados con la Aplicación, incluyendo marcas comerciales, logotipos y contenido, son propiedad de EscuChamos o de sus licenciantes.\n\n'
                      '   5.2. Uso de la Marca\n'
                      '   No se permite el uso de las marcas comerciales, logotipos o cualquier otro contenido protegido sin el consentimiento previo y por escrito de EscuChamos.\n\n'
                      '6. Terminación\n'
                      '   6.1. Terminación del Servicio\n'
                      '   EscuChamos se reserva el derecho de suspender o terminar tu acceso a la Aplicación en cualquier momento, por cualquier motivo, sin previo aviso.\n\n'
                      '   6.2. Efectos de la Terminación\n'
                      '   En caso de terminación, se eliminarán todos los datos asociados con tu cuenta, y se perderá el acceso a los contenidos y servicios asociados.\n\n'
                      '7. Exención de Responsabilidad\n'
                      '   7.1. Uso de la Aplicación\n'
                      '   La Aplicación se proporciona "tal cual" y "según disponibilidad". No garantizamos que la Aplicación esté libre de errores, interrupciones o que cumpla con tus expectativas.\n\n'
                      '   7.2. Limitación de Responsabilidad\n'
                      '   En la medida permitida por la ley, EscuChamos no será responsable de ningún daño indirecto, incidental, especial o consecuente que resulte del uso o la imposibilidad de uso de la Aplicación.\n\n'
                      '8. Modificaciones a los Términos\n'
                      '   EscuChamos puede modificar estos Términos en cualquier momento. Las modificaciones entrarán en vigencia inmediatamente después de su publicación en la Aplicación. Tu uso continuado de la Aplicación después de la publicación de los Términos modificados constituye tu aceptación de los nuevos Términos.\n\n'
                      '9. Ley Aplicable y Jurisdicción\n'
                      '   Estos Términos se regirán e interpretarán de acuerdo con las leyes del país en el que se encuentre la sede de EscuChamos. Cualquier disputa derivada de estos Términos será resuelta en los tribunales competentes de dicha jurisdicción.\n\n'
                      '10. Contacto\n'
                      '   Si tienes preguntas sobre estos Términos, puedes contactarnos en ',
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
                TextSpan(
                  text: ApiUrl.Correo,
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.5,
                    color: AppColors.primaryBlue, // Color destacado
                    fontWeight: FontWeight.bold, // Negrita
                  ),
                ),
              ],
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
            foregroundColor: Colors.white, // Color del texto blanco
            backgroundColor: AppColors.primaryBlue, // Color de fondo del botón
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Relleno del botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Bordes redondeados del botón
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
