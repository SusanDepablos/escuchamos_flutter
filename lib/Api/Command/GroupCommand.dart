
//Flutter native support
import 'package:flutter/material.dart';
//Api support
import 'dart:io';
import 'package:escuchamos_flutter/Api/Model/GroupModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Service/GroupService.dart';

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
