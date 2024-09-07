import 'package:http/http.dart' as http;
import 'package:escuchamos_flutter/Api/Response/ServiceResponse.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';

final FlutterSecureStorage _storage = FlutterSecureStorage();

class UserShow {
  Future<ServiceResponse> showUser(int id) async {
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
class UploadPhoto {
  Future<ServiceResponse> photoUpload(File file, String type) async {

    final url = Uri.parse('${ApiUrl.baseUrl}user/upload/photo/');
    final token = await _storage.read(key: 'token') ?? '';

    final headers = {
      'Authorization': 'Token $token',
    };

    // Crear una solicitud multipart
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);

    // Adjuntar el archivo y el tipo al cuerpo del formulario
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.fields['type'] = type;

    // Enviar la solicitud
    final streamedResponse = await request.send();

    // Convertir la respuesta en formato `ServiceResponse`
    final response = await http.Response.fromStream(streamedResponse);
    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }
}

class DeletePhoto {
  Future<ServiceResponse> photoDelete(String type) async {
    // Define el URL al que se enviará la solicitud POST
    final url = Uri.parse('${ApiUrl.baseUrl}user/upload/photo/');
    final token = await _storage.read(key: 'token') ?? '';

    // Define el cuerpo de la solicitud POST
    final body = jsonEncode({
      'type': type,
    });

    // Define las cabeceras para la solicitud
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token', // Añadir el token en las cabeceras
    };

    final response = await http.delete(
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

class VerifyPasswords {
  Future<ServiceResponse> verifyPassword(
      String password) async {
    final url = Uri.parse('${ApiUrl.baseUrl}user/verify/password/');
    final token = await _storage.read(key: 'token') ?? '';

    final body = jsonEncode({
      'password': password,
    });

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    final response = await http.post(
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

class ChangePassword {
  Future<ServiceResponse> changePassword(
      String old_password, new_password) async {
    final url = Uri.parse('${ApiUrl.baseUrl}user/change/password/');
    final token = await _storage.read(key: 'token') ?? '';

    final body = jsonEncode({
      'old_password': old_password,
      'new_password': new_password,
    });

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
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

class UserIndex {
  Future<ServiceResponse> fetchData(Map<String, String?> filters) async {

    var uri = Uri.parse('${ApiUrl.baseUrl}user/'); // Cambié a user/
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
