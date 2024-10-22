import 'package:http/http.dart' as http;
import 'package:escuchamos_flutter/Api/Response/ServiceResponse.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:convert';

class SessionInfoService {
  Future<ServiceResponse> sessioninfo(String body) async {
    final url = Uri.parse('${ApiUrl.baseUrl}session/info/');

    final headers = {
      'Content-Type': 'application/json',
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
