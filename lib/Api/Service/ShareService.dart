import 'package:http/http.dart' as http;
import 'package:escuchamos_flutter/Api/Response/ServiceResponse.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage _storage = FlutterSecureStorage();

class ShareService {
  Future<ServiceResponse> fetchData(Map<String, String?> filters) async {

    var uri = Uri.parse('${ApiUrl.baseUrl}share/');
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

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    var response = await http.get(uri, headers: headers);

    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }
}

class SharePost {
  Future<ServiceResponse> postReport(
    int postId) async {
    final url = Uri.parse('${ApiUrl.baseUrl}share/');
    final token = await _storage.read(key: 'token') ?? '';

    final body = jsonEncode({
      'post_id': postId,
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

