
//Flutter native support
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:escuchamos_flutter/Api/Model/GroupModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Service/GroupService.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';

class GroupCommandIndex {
  final GroupIndex _fetchData;

  GroupCommandIndex(this._fetchData);

  Future<dynamic> execute() async {
    try {
      var serviceResponse = await _fetchData.fetchData();

      if (serviceResponse.statusCode == 200) {
        return GroupsModel.fromJson(serviceResponse.body);
      } else {
        return InternalServerError.fromServiceResponse(serviceResponse);
      }
    } on SocketException catch (e) {
      return ApiError();
    } on FlutterError catch (flutterError) {
      throw Exception(
          'Error en la aplicación Flutter: ${flutterError.message}');
    }
  }
}

class GroupCommandUpdate {
  final GroupUpdate _updateGroup;

  GroupCommandUpdate(this._updateGroup);

  Future<dynamic> execute(int groupId, int id) async {
    try {
      var response = await _updateGroup.updateGroup(groupId, id);

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
