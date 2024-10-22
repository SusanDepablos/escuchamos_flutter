
//Flutter native support
import 'package:flutter/material.dart';
//Api support
import 'dart:io';
import 'package:escuchamos_flutter/Api/Service/SessionService.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';

class SessionInfoCommand {
  final SessionInfoService _sessionInfoService;

  SessionInfoCommand(this._sessionInfoService);

  Future<dynamic> execute({
    required String body,
  }) async {
    try {
      var response = await _sessionInfoService.sessioninfo(body);

      if (response.statusCode == 200) {
        return response.body['exists'];
      } else {
        return SimpleErrorResponse.fromServiceResponse(response);
      }
    } on SocketException catch (e) {
      return ApiError();
    } on FlutterError catch (flutterError) {
      throw Exception(
          'Error en la aplicación Flutter: ${flutterError.message}');
    }
  }
}

