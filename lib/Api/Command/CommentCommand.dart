//Flutter native support
import 'package:flutter/material.dart';
//Api support
import 'dart:io';
import 'package:escuchamos_flutter/Api/Service/CommentService.dart';
import 'package:escuchamos_flutter/Api/Model/CommentModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';

class CommentCommandIndex {
  final CommentIndex _commentData;
  final Map<String, String?>? filters;

  CommentCommandIndex(this._commentData, [this.filters]);

  Future<dynamic> execute() async {
    try {
      var response = await _commentData.fetchData(filters ?? {}); 

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

class CommentCommandShow {
  final CommentShow _commentShowService;
  final int id;

  CommentCommandShow(this._commentShowService, this.id);

  Future<dynamic> execute() async {
    try {
      var response = await _commentShowService.showcomment(id);

      if (response.statusCode == 200) {
        return CommentModel.fromJson(response.body);
      } else if (response.statusCode == 404) {
        return SimpleErrorResponse.fromServiceResponse(response);
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

class UploadCommandComment {
  final CommentService _commentService;

  UploadCommandComment(this._commentService);

  Future<dynamic> execute({
    required String? body,
    required String postId,
    String? commentId,
    File? file,
  }) async {
    try {

      var response =
          await _commentService.addComment(body, postId, commentId, file);

      if (response.statusCode == 201) {
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

