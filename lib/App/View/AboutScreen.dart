import 'package:escuchamos_flutter/App/Widget/Label.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart'; // Asegúrate de importar tus constantes de colores
import 'package:escuchamos_flutter/App/Widget/Logo.dart'; // Asegúrate de tener un widget para el logo
import 'package:escuchamos_flutter/App/Widget/Icons.dart';
import 'package:url_launcher/url_launcher.dart';



class AboutScreen extends StatelessWidget {

void _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'No se pudo abrir el enlace: $url';
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteapp,
      appBar: AppBar(
        backgroundColor: AppColors.whiteapp,
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            // Ícono de retroceso en el lado izquierdo
            Positioned(
              left: 0,
              top: 9, // Ajusta este valor para controlar cuánto quieres bajar el ícono
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () {
                  Navigator.pop(context); // Regresa a la pantalla anterior
                },
              ),
            ),
            // Centra el LogoBanner en el AppBar
            Center(
              child: LogoBanner(), // Inserta el LogoBanner centrado
            ),
          ],
        ),
        centerTitle: true, // Mantiene el título centrado visualmente
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección: ¿Quiénes Somos?
              _buildSectionTitle('¿Quiénes Somos?'),
              _buildSectionContent(
                'Somos una comunidad en Rubio, Táchira, dedicada a transformar nuestro entorno social y cultural. EscuChamos nació en 2021 con la misión de empoderar a mujeres y jóvenes, liderando un cambio positivo en sus comunidades.',
              ),     
              // Sección: Nuestra Misión
              _buildSectionTitle('Nuestra Misión'),
              _buildSectionContent(
                'Fortalecemos a las comunidades mediante educación y comunicación, promoviendo la identidad comunitaria, la resolución pacífica de conflictos y el emprendimiento.',
              ),
              // Sección: Nuestra Visión
              _buildSectionTitle('Nuestra Visión'),
              _buildSectionContent(
                'Ser una red de ciudadanos proactivos y conectados, capaces de generar cambios sostenibles en sus vidas y en sus comunidades, tanto a nivel local como global.',
              ),
              // Sección: ¿Qué Hacemos?
              _buildSectionTitle('¿Qué Hacemos?'),
              _buildSectionContent(
                'Liderazgo Comunitario: Empoderamos a mujeres y jóvenes como líderes del cambio.\n\n'
                'Identidad Comunitaria: Fomentamos un sentido de pertenencia y solidaridad.\n\n'
                'Emprendimiento: Ofrecemos herramientas para desarrollar proyectos de vida.',
              ),
              // Sección: La App EscuChamos
              _buildSectionTitle('La App EscuChamos'),
              _buildSectionContent(
                'La app "EscuChamos" es tu puerta a una participación más activa y directa con nuestra comunidad. Mantente informado, participa en nuestras actividades y conecta con otros miembros de manera fácil y rápida.',
              ),
              // Sección: Nuestro Compromiso
              _buildSectionTitle('Nuestro Compromiso'),
              _buildSectionContent(
                'Estamos comprometidos con la innovación y el uso de tecnología para fortalecer el tejido social. Con esta app, queremos asegurarnos de que estés siempre conectado y puedas contribuir al cambio.',
              ),
              LogoIcon(size: 150.0),
              // Enlaces de redes sociales o sitio web
              Center(
                child: Text(
                  'Conéctate con nosotros:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LabelAction(
                      icon: MaterialIcons.web,
                      onPressed: () {
                        _launchURL(ApiUrl.WebSite); // Reemplaza con tu URL
                      },
                    ),
                    SizedBox(width: 24.0), // Espacio entre íconos
                    LabelAction(
                      icon: MaterialIcons.facebook,
                      onPressed: () {
                        _launchURL(ApiUrl.Facebook); // Reemplaza con tu enlace de Facebook
                      },
                    ),
                    SizedBox(width: 24.0), // Espacio entre íconos
                    LabelAction(
                      icon: MaterialIcons.email,
                      onPressed: () {
                        _launchURL(ApiUrl.Facebook); // Reemplaza con tu correo electrónico
                      },
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.inputLigth, height: 40.0),
              // Información de versión
              Center(
                child: Text(
                  'Versión 1.0.0',
                  style: TextStyle(fontSize: 14.0, color: AppColors.inputDark),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Método para construir títulos de sección
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
    );
  }

  // Método para construir contenido de sección
  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(
        content,
        style: TextStyle(fontSize: 16.0, color: AppColors.black),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
