//Flutter native support
import 'package:flutter/material.dart';
//Api support
import 'dart:io';
import 'package:escuchamos_flutter/Api/Service/PostService.dart';
import 'package:escuchamos_flutter/Api/Model/PostModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';

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

class PostCommandCreate {
  final PostCreate _postCreateService;

  PostCommandCreate(this._postCreateService);

  Future<dynamic> execute({
    String? body, 
    int? typePost, 
    int? postId,
    List<File>? files}) async {
    try {
      var response = await _postCreateService.createPost(
        body: body,  
        typePost: typePost,
        postId: postId,
        files: files,
      );

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

class PostCommandShow {
  final PostShow _postShowService;
  final int id;

  PostCommandShow(this._postShowService, this.id);

  Future<dynamic> execute() async {
    try {
      var response = await _postShowService.showpost(id);

      if (response.statusCode == 200) {
        return PostModel.fromJson(response.body);
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

class PostCommandUpdate {
  final PostUpdate _postUpdateService;

  PostCommandUpdate(this._postUpdateService);

  Future<dynamic> execute(
      String bodyPost, int id) async {
    try {
      var response = await _postUpdateService.updatePost(
          bodyPost, id);

      if (response.statusCode == 200) {
        return SuccessResponse.fromServiceResponse(response);
      } else if (response.statusCode == 500) {
        return InternalServerError.fromServiceResponse(response);
      } else {
        var content =
            response.body['validation'] ?? response.body['error'];
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

class DeleteCommandPost {
  final DeletePost _postDeleteService;

  DeleteCommandPost(this._postDeleteService);

  Future<dynamic> execute({required int id}) async {
    try {
      // Llamar a la función PostUpload con los parámetros file y type
      var response = await _postDeleteService.postDelete(id);

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
