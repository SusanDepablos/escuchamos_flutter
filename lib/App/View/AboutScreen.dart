import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Label.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Logo.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  // Método para abrir URLs utilizando url_launcher
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    print('Intentando abrir la URL: $url');

    if (!await launchUrl(uri)) {
      throw Exception('No se pudo abrir la URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteapp,
      appBar: AppBar(
        backgroundColor: AppColors.whiteapp,
        title: Row(
          children: [
            Center(
              child: LogoBanner(), // Aquí se inserta el LogoBanner en el AppBar
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('¿Quiénes Somos?'),
              _buildSectionContent(
                'Somos una comunidad en Rubio, Táchira, dedicada a transformar nuestro entorno social y cultural. EscuChamos nació en 2021 con la misión de empoderar a mujeres y jóvenes, liderando un cambio positivo en sus comunidades.',
              ),
              _buildSectionTitle('Nuestra Misión'),
              _buildSectionContent(
                'Fortalecemos a las comunidades mediante educación y comunicación, promoviendo la identidad comunitaria, la resolución pacífica de conflictos y el emprendimiento.',
              ),
              _buildSectionTitle('Nuestra Visión'),
              _buildSectionContent(
                'Ser una red de ciudadanos proactivos y conectados, capaces de generar cambios sostenibles en sus vidas y en sus comunidades, tanto a nivel local como global.',
              ),
              _buildSectionTitle('¿Qué Hacemos?'),
              _buildSectionContent(
                'Liderazgo Comunitario: Empoderamos a mujeres y jóvenes como líderes del cambio.\n\n'
                'Identidad Comunitaria: Fomentamos un sentido de pertenencia y solidaridad.\n\n'
                'Emprendimiento: Ofrecemos herramientas para desarrollar proyectos de vida.',
              ),
              _buildSectionTitle('La App EscuChamos'),
              _buildSectionContent(
                'La app "EscuChamos" es tu puerta a una participación más activa y directa con nuestra comunidad. Mantente informado, participa en nuestras actividades y conecta con otros miembros de manera fácil y rápida.',
              ),
              _buildSectionTitle('Nuestro Compromiso'),
              _buildSectionContent(
                'Estamos comprometidos con la innovación y el uso de tecnología para fortalecer el tejido social. Con esta app, queremos asegurarnos de que estés siempre conectado y puedas contribuir al cambio.',
              ),
              LogoIcon(size: 150.0),
              const Center(
                child: Text(
                  'Conéctate con nosotros:',
                  style: TextStyle(
                    fontSize: AppFond.title,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  textScaleFactor: 1.0,
                ),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LabelAction(
                        icon: MaterialIcons.web,
                        iconSize: 30.0,
                        onPressed: () {
                          _launchURL('https://asociacioncivilescuchamos.onrender.com');
                        },
                      ),
                    ),
                    const SizedBox(width: 24.0),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LabelAction(
                        icon: MaterialIcons.facebook,
                        iconSize: 30.0,
                        onPressed: () {
                          // Intentar abrir la app de Facebook, si no está, abrir el enlace en el navegador
                          final Uri facebookUri = Uri.parse('fb://facewebmodal/f?href=https://www.facebook.com/profile.php?id=100075837644778&mibextid=ZbWKwL');
                          final Uri fallbackUri = Uri.parse('https://www.facebook.com/profile.php?id=100075837644778&mibextid=ZbWKwL');

                          // Verifica si la app de Facebook está instalada
                          canLaunchUrl(facebookUri).then((isInstalled) {
                            if (isInstalled) {
                              launchUrl(facebookUri);
                            } else {
                              launchUrl(fallbackUri);
                            }
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 24.0),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LabelAction(
                        icon: MaterialIcons.email,
                        iconSize: 30.0,
                        onPressed: () {
                          _launchURL('mailto:escuchamos2024@gmail.com');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.inputLigth, height: 40.0),
              const Center(
                child: Text(
                  'Versión 1.0.0',
                  style: TextStyle(fontSize: AppFond.subtitle, color: AppColors.inputDark),
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
        style: const TextStyle(
          fontSize: AppFond.title,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
        textScaleFactor: 1.0,
      ),
    );
  }

  // Método para construir contenido de sección
  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(
        content,
        style: const TextStyle(fontSize: AppFond.subtitle, color: AppColors.black),
        textAlign: TextAlign.justify,
        textScaleFactor: 1.0,
      ),
    );
  }
}

// Asegúrate de que el widget LabelAction esté preparado para aceptar iconSize
class LabelAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double iconSize;

  const LabelAction({
    required this.icon,
    required this.onPressed,
    this.iconSize = 24.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: iconSize),
      onPressed: onPressed,
    );
  }
}
