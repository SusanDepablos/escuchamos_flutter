// lib/App/Widget/UserListView.dart
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';

class UserListView extends StatefulWidget {
  final List<Datum> users; // Usar List<Datum> en lugar de UsersModel
  final ScrollController scrollController;

  UserListView({required this.users, required this.scrollController});

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: widget.scrollController,
        itemCount: widget.users.length,
        itemBuilder: (context, index) {
          final user = widget.users[index];
          return ListTile(
            title: Text(user.attributes.name ?? 'Nombre no disponible'),
            subtitle: Text(
                '${user.attributes.email ?? 'Email no disponible'}, ${user.attributes.phoneNumber ?? 'Número no disponible'}'),
          );
        },
      ),
    );
  }
}
