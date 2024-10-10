//Flutter native support
import 'package:flutter/material.dart';
//Api support
import 'dart:io';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Service/ReportService.dart';
import 'package:escuchamos_flutter/Api/Model/ReportModels.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';

// class ReportCommandIndex {
//   final ReportIndex _reportsData;
//   final Map<String, String?>? filters;

//   ReportCommandIndex(this._reportsData, [this.filters]);

//   Future<dynamic> execute() async {
//     try {
//       var response =
//           await _reportsData.fetchData(filters ?? {}); 

//       if (response.statusCode == 200) {
//         return ReportsModel.fromJson(response.body);
//       } else {
//         return InternalServerError.fromServiceResponse(response);
//       }
//     } on SocketException catch (e) {
//       return ApiError();
//     } on FlutterError catch (flutterError) {
//       throw Exception(
//           'Error en la aplicación Flutter: ${flutterError.message}');
//     }
//   }
// }

class ReportGroupedCommandIndex {
  final ReportGroupedIndex _reportsGroupedData;
  final Map<String, String?>? filters;

  ReportGroupedCommandIndex(this._reportsGroupedData, [this.filters]);

  Future<dynamic> execute() async {
    try {
      var response =
          await _reportsGroupedData.fetchData(filters ?? {}); 

      if (response.statusCode == 200) {
        return ReportsGroupedModel.fromJson(response.body);
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

class ReportCommandPost {
  final ReportPost _reportService;

  ReportCommandPost(this._reportService);

  Future<dynamic> execute(
    String model, int objectId, String observation,
  ) async {
    try {
      var response =
          await _reportService.postReport(model, objectId, observation);

      if (response.statusCode == 200 || response.statusCode == 201) {
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

