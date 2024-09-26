import 'package:http/http.dart' as http;
import 'package:escuchamos_flutter/Api/Response/ServiceResponse.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage _storage = FlutterSecureStorage();

class PostIndex {
  Future<ServiceResponse> fetchData(Map<String, String?> filters) async {

    var uri = Uri.parse('${ApiUrl.baseUrl}post/');
    final token = await _storage.read(key: 'token') ?? '';

    if (filters.isNotEmpty) {
      final queryString = filters.entries
          .where((entry) => entry.value != null && entry.value!.isNotEmpty)
          .map((entry) => '${entry.key}=${entry.value}')
          .join('&');

      if (queryString.isNotEmpty) {
        uri = uri.replace(query: queryString);
      }
    }

    // Define los encabezados
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    // Realiza la solicitud con encabezados
    var response = await http.get(uri, headers: headers);

    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }
}

class PostCreate {
  Future<ServiceResponse> createPost({
    String? body,
    int? typePost,
    List<File>? files,
    }) async {

    final url = Uri.parse('${ApiUrl.baseUrl}post/');
    final token = await _storage.read(key: 'token') ?? '';

    final headers = {
        'Authorization': 'Token $token',
      };

      // Crear una solicitud multipart
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);

      // Adjuntar múltiples archivos al cuerpo del formulario bajo el mismo campo 'file'
      if (files != null) {
        for (var file in files) {
          request.files.add(await http.MultipartFile.fromPath('file', file.path));
        }
      }

      // Agregar otros campos solo si no son nulos
      if (body != null && body.isNotEmpty) {
        request.fields['body'] = body;
      }
      request.fields['type_post_id'] = typePost.toString(); 

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);
    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }
}

class PostShow {
  Future<ServiceResponse> showpost(int id) async {
    final url = Uri.parse('${ApiUrl.baseUrl}post/$id/');
    final token = await _storage.read(key: 'token') ?? '';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

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
