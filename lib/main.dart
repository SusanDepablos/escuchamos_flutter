import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Asegúrate de tener esta importación
import 'Routes/Routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');

  runApp(MyApp(initialRoute: token != null && token.isNotEmpty ? 'index' : 'login'));
}


class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EscuChamos',
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', ''), // Español
        // Otros idiomas si los necesitas
      ],
      locale: const Locale('es', ''), // Establece el idioma predeterminado a español
    );
  }
}
