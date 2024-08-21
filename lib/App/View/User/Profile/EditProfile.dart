import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Vista Básica en Flutter'),
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
