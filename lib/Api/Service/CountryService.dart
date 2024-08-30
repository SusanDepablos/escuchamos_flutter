import 'package:http/http.dart' as http;
import 'package:escuchamos_flutter/Api/Response/ServiceResponse.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CountryIndex {
  Future<ServiceResponse> fetchData() async {
    final FlutterSecureStorage _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token') ?? '';

    var uri = Uri.parse('${ApiUrl.baseUrl}country/');

    // Definir los encabezados
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    // Realizar la solicitud HTTP
    var response = await http.get(uri, headers: headers);

    // Procesar la respuesta
    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }
}


