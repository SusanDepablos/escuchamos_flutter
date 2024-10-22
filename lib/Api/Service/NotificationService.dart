import 'package:http/http.dart' as http;
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage _storage = FlutterSecureStorage();

class NotificationService {
  Future<void> fetchNotifications() async {
    final id = await _storage.read(key: 'user') ?? '0';
    var uri = Uri.parse('${ApiUrl.baseUrl}notifications/$id/');

    final headers = {
      'Content-Type': 'text/event-stream',
    };

    try {
      http.Client()
          .send(http.Request('GET', uri)..headers.addAll(headers))
          .asStream()
          .listen((response) {
        response.stream.transform(utf8.decoder).listen((eventData) {
          if (eventData.isNotEmpty) {
            _processData(eventData);
          }
        });
      });
    } catch (e) {
      print('Error al recibir notificaciones: $e');
    }
  }

  void _processData(String data) {
    if (data.startsWith('data: ')) {
      data = data.substring(6);
    }

    data = data.replaceAll("'", '"');

    try {
      Map<String, dynamic> jsonData = jsonDecode(data);
      print('Notificación recibida: ${jsonData['notifications']}');
    } catch (e) {
      print('Error al decodificar JSON: $e');
    }
  }
}
