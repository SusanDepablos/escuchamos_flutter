//Flutter native support
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:escuchamos_flutter/Api/Model/StatusModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Service/StatusService.dart';

class StatusCommandIndex {
  final StatusIndex _statusesData;

  StatusCommandIndex(this._statusesData);

  Future<dynamic> execute() async {
    try {
      var serviceResponse = await _statusesData.fetchData();

      if (serviceResponse.statusCode == 200) {
        return StatusesModel.fromJson(serviceResponse.body);
      } else {
        return InternalServerError.fromServiceResponse(serviceResponse);
      }
    } on SocketException catch (e) {
      return ApiError();
    } on FlutterError catch (flutterError) {
      throw Exception(
          'Error en la aplicación Flutter: ${flutterError.message}');
    }
  }
}