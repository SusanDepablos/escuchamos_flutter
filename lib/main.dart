import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Routes/Routes.dart';
import 'package:escuchamos_flutter/PreMain.dart';

void main() async {

  final preMain = PreMain();
  await preMain.initializeApp();
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