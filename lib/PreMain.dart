// PreMain.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/main.dart';
import 'package:escuchamos_flutter/Api/Command/SessionCommand.dart';
import 'package:escuchamos_flutter/Api/Service/SessionService.dart';
import 'dart:convert';
import 'Api/Service/NotificationService.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final FlutterSecureStorage _storage = FlutterSecureStorage();

class PreMain {

  Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      print('No hay conexión a Internet.');
    } else {
      Map<String, String> allValues = await _storage.readAll();

      if (allValues.isNotEmpty) {
        final body = {
          'user_id': await _storage.read(key: 'user'),
          'session_key': await _storage.read(key: 'session_key'),
        };

        final response = await SessionInfoCommand(SessionInfoService())
          .execute(body: json.encode(body));

        if (response == true) {
          NotificationService().fetchNotifications();
          runApp(MyApp(initialRoute: 'base'));
        } else {
          await _storage.deleteAll();
        }
      }
      runApp(MyApp(initialRoute: 'login'));
    }
  }
}
