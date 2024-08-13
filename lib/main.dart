import 'package:escuchamos_flutter/Routes/Routes.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EscuChamos',
      initialRoute: 'login',
      routes: AppRoutes.routes,
    );
  }
}
