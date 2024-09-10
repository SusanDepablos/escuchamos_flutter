//Flutter native support
import 'package:flutter/material.dart';
//Api support
import 'dart:io';
import 'package:escuchamos_flutter/Api/Model/FollowModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Service/FollowsService.dart';

class FollowsCommandIndex {
  final FollowsIndex _followsData;
  final Map<String, String?>? filters;

  FollowsCommandIndex(this._followsData, [this.filters]);

  Future<dynamic> execute() async {
    try {
      var response =
          await _followsData.fetchData(filters ?? {}); 

      if (response.statusCode == 200) {
        return FollowsModel.fromJson(response.body);
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

