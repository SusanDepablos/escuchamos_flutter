//Flutter native support
import 'package:flutter/material.dart';
import 'dart:convert';
//Api support
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Api/Service/AuthService.dart';
import 'package:escuchamos_flutter/Api/Response/ServiceResponse.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Response/LoginResponse.dart';


class UserCommandLogin {
  final UserLogin _loginUserService;

  UserCommandLogin(this._loginUserService);

  Future<dynamic> execute(
      String username, String password) async {
    try {
      var response = await _loginUserService.loginUser(username, password);
      
      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.body);

        // Guarda el token y userId en el almacenamiento seguro
        final storage = FlutterSecureStorage();
        await storage.write(key: 'token', value: loginResponse.token);
        await storage.write(key: 'user', value: loginResponse.user.toString());
        await storage.write(key: 'groups', value: json.encode(loginResponse.groups));

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
    }on SocketException catch (e) {
        return ApiError();
    }on FlutterError catch (flutterError) {
      throw Exception(
        'Error en la aplicación Flutter: ${flutterError.message}');
    }
  }
}

class UserCommandLogout {
  final UserLogout _logoutUserService;

  UserCommandLogout(this._logoutUserService);

  Future<dynamic> execute(String token) async {
    try {
      var response = await _logoutUserService.logoutUser(token);

      if (response.statusCode == 200) {
        // Eliminar el token y la información del usuario del almacenamiento seguro
        final storage = FlutterSecureStorage();
        await storage.delete(key: 'token');
        await storage.delete(key: 'user');
        await storage.delete(key: 'groups');

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
    }on SocketException catch (e) {
        return ApiError();
    }on FlutterError catch (flutterError) {
      throw Exception(
        'Error en la aplicación Flutter: ${flutterError.message}');
    }
  }
}


class UserCommandRegister {
  final UserRegister _registerUserService;

  UserCommandRegister(this._registerUserService);

  Future<dynamic> execute(
      String name, String username, String password, String email, String birthdate) async {
    try {
      var response = await _registerUserService.registerUser(name, username, password, email, birthdate);
      
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
    }on SocketException catch (e) {
        return ApiError();
    }on FlutterError catch (flutterError) {
      throw Exception(
        'Error en la aplicación Flutter: ${flutterError.message}');
    }
  }
}







