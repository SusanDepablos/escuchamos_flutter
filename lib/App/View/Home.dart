import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/App/Widget/PopupWindow.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:convert';

class Home extends StatelessWidget {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> _getData() async {
    final token = await _storage.read(key: 'token') ?? '';
    final session_key = await _storage.read(key: 'session_key') ?? '';
    final user = await _storage.read(key: 'user') ?? '';
    final groupsString = await _storage.read(key: 'groups') ?? '[]';
    final groups = (groupsString.isNotEmpty) ? List<dynamic>.from(json.decode(groupsString)) : [];

    return {
      'token': token,
      'session_key': session_key,
      'user': user,
      'groups': groups,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final data = snapshot.data!;
        final token = data['token'] as String;
        final session_key = data['session_key'] as String;
        final user = data['user'] as String;
        final groups = data['groups'] as List<dynamic>;

        return Scaffold(
          backgroundColor: AppColors.whiteapp,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Token: $token', style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text('Session: $session_key', style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text('User: $user', style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text('Groups: ${groups.join(', ')}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

