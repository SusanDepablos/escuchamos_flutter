//Flutter native support
import 'package:flutter/material.dart';
//Api support
import 'dart:io';
import 'package:escuchamos_flutter/Api/Service/PostService.dart';
import 'package:escuchamos_flutter/Api/Model/PostModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';

class PostCommandIndex {
  final PostIndex _postData;
  final Map<String, String?>? filters;

  PostCommandIndex(this._postData, [this.filters]);

  Future<dynamic> execute() async {
    try {
      var response =
          await _postData.fetchData(filters ?? {}); 

      if (response.statusCode == 200) {
        return PostsModel.fromJson(response.body);
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

