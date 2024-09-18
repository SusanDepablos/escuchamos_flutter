//Flutter native support
import 'package:flutter/material.dart';
//Api support
import 'dart:io';
import 'package:escuchamos_flutter/Api/Service/CommentService.dart';
import 'package:escuchamos_flutter/Api/Model/CommentModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';

class CommentCommandIndex {
  final CommentIndex _commenttData;
  final Map<String, String?>? filters;

  CommentCommandIndex(this._commenttData, [this.filters]);

  Future<dynamic> execute() async {
    try {
      var response = await _commenttData.fetchData(filters ?? {}); 

      if (response.statusCode == 200) {
        return CommentsModel.fromJson(response.body);
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

