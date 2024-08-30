import 'package:http/http.dart' as http;
import 'package:escuchamos_flutter/Api/Response/ServiceResponse.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserShow {
  Future<ServiceResponse> showUser(int id) async {
    final FlutterSecureStorage _storage = FlutterSecureStorage();
    final url = Uri.parse('${ApiUrl.baseUrl}user/$id/');
    final token = await _storage.read(key: 'token') ?? '';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token', // Añadir el token en las cabeceras
    };

    // Realiza la solicitud POST
    final response = await http.get(
      url,
      headers: headers,
    );

    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }
}

class ProfileUpdate {
  Future<ServiceResponse> updateProfile(String name, String biography, String birthdate) async {
    final FlutterSecureStorage _storage = FlutterSecureStorage();
    // Define el URL al que se enviará la solicitud POST
    final url = Uri.parse('${ApiUrl.baseUrl}user/update/');
    final token = await _storage.read(key: 'token') ?? '';

    // Define el cuerpo de la solicitud POST
    final body = jsonEncode({
      'name': name.isNotEmpty ? name : " ",
      'biography': biography.isNotEmpty ? biography : " ",
      'birthdate': birthdate.isNotEmpty ? birthdate : " ",

    });

    // Define las cabeceras para la solicitud
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token', // Añadir el token en las cabeceras
    };

    final response = await http.put(
      url,
      headers: headers,
      body: body,
    );

    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }
}

class AccountUpdate {
  Future<ServiceResponse> updateAccount(String body) async {
    final FlutterSecureStorage _storage = FlutterSecureStorage();

    final url = Uri.parse('${ApiUrl.baseUrl}user/update/');
    final token = await _storage.read(key: 'token') ?? '';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: body,
      );

      return ServiceResponse.fromJsonString(
        utf8.decode(response.bodyBytes),
        response.statusCode,
      );
    } catch (e) {
      // Manejo de errores de red o de HTTP
      throw Exception('Error al actualizar la cuenta: $e');
    }
  }
}


  