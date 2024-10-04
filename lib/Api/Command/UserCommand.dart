//Flutter native support
import 'package:flutter/material.dart';
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

class ProfileCommandUpdate {
  final ProfileUpdate _userUpdateService;

  ProfileCommandUpdate(this._userUpdateService);

  Future<dynamic> execute(
      String name, String biography, String birthdate,) async {
    try {
      var response = await _userUpdateService.updateProfile(
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

class AccountCommandUpdate {
  final AccountUpdate _userUpdateService;

  AccountCommandUpdate(this._userUpdateService);

  Future<dynamic> execute({required String body}) async {
    try {
      var response = await _userUpdateService.updateAccount(body);

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

class UploadCommandPhoto {
  final UploadPhoto _userPhotoService;

  UploadCommandPhoto(this._userPhotoService);

  Future<dynamic> execute({required File file, required String type}) async {
    try {
      // Llamar a la función photoUpload con los parámetros file y type
      var response = await _userPhotoService.photoUpload(file, type);

      // Manejar la respuesta según el código de estado
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

class DeleteCommandPhoto {
  final DeletePhoto _userPhotoService;

  DeleteCommandPhoto(this._userPhotoService);

  Future<dynamic> execute({required String type}) async {
    try {
      // Llamar a la función photoUpload con los parámetros file y type
      var response = await _userPhotoService.photoDelete(type);

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

class VerifyPasswordCommand {
  final VerifyPasswords _userService;

  VerifyPasswordCommand(this._userService);

  Future<dynamic> execute(
    String password,
  ) async {
    try {
      var response =
          await _userService.verifyPassword(password);

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


class ChangePasswordCommand {
  final ChangePassword _userService;

  ChangePasswordCommand(this._userService);

  Future<dynamic> execute(
    String old_password, new_password)
    async {
    try {
      var response =
          await _userService.changePassword(old_password, new_password);

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

class UserCommandIndex {
  final UserIndex _userData; // Cambié a UserIndex
  final Map<String, String?>? filters;

  UserCommandIndex(this._userData, [this.filters]);

  Future<dynamic> execute() async {
    try {
      var response =
          await _userData.fetchData(filters ?? {}); // Cambié a _userData

      if (response.statusCode == 200) {
        return UsersModel.fromJson(response.body); // Cambié a UsersModel
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


class DeleteCommandUser {
  final DeleteUser _userDeleteService;

  DeleteCommandUser(this._userDeleteService);

  Future<dynamic> execute({required int id, required String token}) async {
    try {
      // Llamar a la función PostUpload con los parámetros file y type
      var response = await _userDeleteService.userDelete(id , token);

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
