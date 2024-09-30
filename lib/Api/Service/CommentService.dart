import 'package:http/http.dart' as http;
import 'package:escuchamos_flutter/Api/Response/ServiceResponse.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';

final FlutterSecureStorage _storage = FlutterSecureStorage();

class CommentIndex {
  Future<ServiceResponse> fetchData(Map<String, String?> filters) async {

    var uri = Uri.parse('${ApiUrl.baseUrl}comment/');
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

class CommentShow {
  Future<ServiceResponse> showcomment(int id) async {
    final url = Uri.parse('${ApiUrl.baseUrl}comment/$id/');
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

class CommentCreate {
  Future<ServiceResponse> createComment(
      Map<String, String?>? formData, File? file) async {
    final url = Uri.parse('${ApiUrl.baseUrl}comment/');
    final token = await _storage.read(key: 'token') ?? '';

    final headers = {
      'Authorization': 'Token $token',
    };

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);

    request.fields['post_id'] = formData!['post_id'].toString();

    if (formData['comment_id'] != null) {
      request.fields['comment_id'] = formData['comment_id']!.toString();
    }

    if (formData['body']?.isNotEmpty == true) {
      request.fields['body'] = formData['body']!.toString();
    }

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
    }


    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }
}

