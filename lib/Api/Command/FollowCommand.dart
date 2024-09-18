//Flutter native support
import 'package:flutter/material.dart';
//Api support
import 'dart:io';
import 'package:escuchamos_flutter/Api/Model/FollowModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Service/FollowService.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';

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

class FollowCommandPost {
  final FollowPost _followService;

  FollowCommandPost(this._followService);

  Future<dynamic> execute(
    int followed_user_id,
  ) async {
    try {
      var response =
          await _followService.postFollow(followed_user_id);

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

