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

class CommentCommandCreate {
  final CommentCreate _commentCreate;

  CommentCommandCreate(this._commentCreate);

  Future<dynamic> execute({
    final Map<String, String?>? formData, // Aquí se recibe el Map como está
    File? file,
  }) async {
    try {
      var response = await _commentCreate.createComment(
          formData, file);

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

class CommentCommandUpdate {
  final CommentUpdate _commentUpdateService;

  CommentCommandUpdate(this._commentUpdateService);

  Future<dynamic> execute(String bodyComment, int id) async {
    try {
      var response = await _commentUpdateService.updateComment(bodyComment, id);

      if (response.statusCode == 200) {
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

class CommentCommandDelete {
  final CommentDeleteService _commentDeleteService;

  CommentCommandDelete(this._commentDeleteService);

  Future<dynamic> execute(int id) async {
    try {
      var response = await _commentDeleteService.deleteComment(id);

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

