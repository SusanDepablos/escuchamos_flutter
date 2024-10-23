import 'package:http/http.dart' as http;
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

final ValueNotifier<int> notification = ValueNotifier<int>(0);
final _storage = FlutterSecureStorage();

class NotificationService {
  Future<void> fetchNotifications() async {
    var id = await _storage.read(key: 'user') ?? '0';
    var uri = Uri.parse('${ApiUrl.baseUrl}notifications/$id/');

    try {
      var response = await http.Client().send(http.Request('GET', uri));

      if (response.statusCode != 200) {
        await Future.delayed(Duration(seconds: 15));
        fetchNotifications();
      } else {
        response.stream.transform(utf8.decoder).listen((data) {
          if (data.startsWith('data: ')) {
            data = data.substring(6);
          }
          _processData(jsonDecode(data.replaceAll("'", '"')));
        });
      }
    } on SocketException catch (e) {
      print('Error de conexión a tiempo real: $e');
      await Future.delayed(Duration(seconds: 15));
      fetchNotifications();
    } catch (e) {
      print('Errora tiempo real: $e');
      await Future.delayed(Duration(seconds: 15));
    }
  }

  void _processData(Map<String, dynamic> jsonData) {
    try {
      notification.value = jsonData['notifications']; // Notifica el cambio
    } catch (e) {
      print('Error al procesar los datos: $e');
    }
  }
}
