//Flutter native support
import 'package:flutter/material.dart';
//Api support
import 'dart:io';
import 'package:escuchamos_flutter/Api/Model/ReactionModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Service/ReactionService.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';

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

class ReactionCommandPost {
  final ReactionPost _reactionService;

  ReactionCommandPost(this._reactionService);

  Future<dynamic> execute(
    String model, int object_id,
  ) async {
    try {
      var response =
          await _reactionService.postReaction(model, object_id);

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

