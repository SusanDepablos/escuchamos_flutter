//Flutter native support
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:escuchamos_flutter/Api/Service/NotificationService.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';


class IsSeenCommand {
  final IsSeenService _isSeenService;

  IsSeenCommand(this._isSeenService);

  Future<dynamic> execute() async {
    try {
      var response = await _isSeenService.isSeen();

      if (response.statusCode == 200 || response.statusCode == 202) {
        return SuccessResponse.fromServiceResponse(response);
      } else if (response.statusCode == 500) {
        return InternalServerError.fromServiceResponse(response);
      } else {
        var content = response.body['validation'] ?? response.body['error'];
        if (content is String) {
          return SimpleErrorResponse.fromServiceResponse(response);
        }
        return ValidationResponse.fromServiceResponse(response);
      }
    } on SocketException {
      return ApiError();
    } on FlutterError catch (flutterError) {
      throw Exception(
          'Error en la aplicación Flutter: ${flutterError.message}');
    }
  }
}
