import 'package:http/http.dart' as http;
import 'package:escuchamos_flutter/Api/Response/ServiceResponse.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage _storage = FlutterSecureStorage();

class GroupIndex {
  Future<ServiceResponse> fetchData() async {
    final token = await _storage.read(key: 'token') ?? '';

    var uri = Uri.parse('${ApiUrl.baseUrl}group/');

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
