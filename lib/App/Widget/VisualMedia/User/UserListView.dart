import 'package:flutter/material.dart';

class UserListView extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String url;


  UserListView({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // title: Text(name.isNotEmpty ? name : 'Nombre no disponible'),
      subtitle: Text(
          '${email.isNotEmpty ? email : 'Email no disponible'}, ${phoneNumber.isNotEmpty ? phoneNumber : 'Número no disponible'}'),
      title: Text(url.isNotEmpty ? url: 'No disponible')
    );
  }
}
