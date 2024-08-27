//Flutter native support
import 'package:flutter/material.dart';
import 'dart:convert';
//Api support
import 'dart:io';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';

class UserCommandShow {
  final UserShow _userShowService;
  final int id;

  UserCommandShow(this._userShowService, this.id);

  Future<dynamic> execute() async {
    try {
      var response = await _userShowService.showUser(id);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.body);
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

class UserCommandUpdate {
  final UserUpdate _userUpdateService;

  UserCommandUpdate(this._userUpdateService);

  Future<dynamic> execute(
      String name, String biography, String birthdate) async {
    try {
      var response = await _userUpdateService.updateUser(
          name, biography, birthdate);

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
