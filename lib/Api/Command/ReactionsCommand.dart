//Flutter native support
import 'package:flutter/material.dart';
//Api support
import 'dart:io';
import 'package:escuchamos_flutter/Api/Model/ReactionModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Service/ReactionsService.dart';

class ReactionsCommandIndex {
  final ReactionsIndex _reactionsData;
  final Map<String, String?>? filters;

  ReactionsCommandIndex(this._reactionsData, [this.filters]);

  Future<dynamic> execute() async {
    try {
      var response =
          await _reactionsData.fetchData(filters ?? {}); 

      if (response.statusCode == 200) {
        return ReactionsModel.fromJson(response.body);
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

