import 'package:http/http.dart' as http;
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/Api/Response/ServiceResponse.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

final FlutterSecureStorage _storage = FlutterSecureStorage();
class IsSeenService {
  Future<ServiceResponse> isSeen() async {
    final url = Uri.parse('${ApiUrl.baseUrl}notifications/seen/');
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
