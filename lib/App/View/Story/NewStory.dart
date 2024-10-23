import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hola App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hola App'),
        ),
        body: Center(
          child: Text(
            'Hola',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}