//Flutter native support
import 'package:escuchamos_flutter/Api/Service/ShareService.dart';
import 'package:flutter/material.dart';
//Api support
import 'dart:io';
import 'package:escuchamos_flutter/Api/Model/ShareModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';

class ShareCommandIndex {
  final ShareIndex _sharesData;
  final Map<String, String?>? filters;

  ShareCommandIndex(this._sharesData, [this.filters]);

  Future<dynamic> execute() async {
    try {
      var response =
          await _sharesData.fetchData(filters ?? {}); 

      if (response.statusCode == 200) {
        return SharesModel.fromJson(response.body);
      } else {
        return InternalServerError.fromServiceResponse(response);
      }
    } on SocketException catch (e) {
      return ApiError();
    } on FlutterError catch (flutterError) {
      throw Exception(
          'Error en la aplicación Flutter: ${flutterError.message}');
    }
  }
}

class ShareCommandPost {
  final SharePost _shareService;

  ShareCommandPost(this._shareService);

  Future<dynamic> execute(
    int postId,
  ) async {
    try {
      var response =
          await _shareService.postReport(postId);

      if (response.statusCode == 200 || response.statusCode == 201) {
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
    } on SocketException catch (e) {
      return ApiError();
    } on FlutterError catch (flutterError) {
      throw Exception(
          'Error en la aplicación Flutter: ${flutterError.message}');
    }
  }
}

class DeleteCommandShare {
  final ShareDelete _shareDeleteService;

  DeleteCommandShare(this._shareDeleteService);

  Future<dynamic> execute({required int id}) async {
    try {
      // Llamar a la función ShareUpload con los parámetros file y type
      var response = await _shareDeleteService.deleteShare(id);

      // Manejar la respuesta según el código de estado
      if (response.statusCode == 202) {
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
    } on SocketException catch (e) {
      return ApiError();
    } on FlutterError catch (flutterError) {
      throw Exception(
          'Error en la aplicación Flutter: ${flutterError.message}');
    }
  }
}


