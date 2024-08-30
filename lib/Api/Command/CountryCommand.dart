
//Flutter native support
import 'package:flutter/material.dart';
//Api support
import 'dart:io';
import 'package:escuchamos_flutter/Api/Model/CountryModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Service/CountryService.dart';

class CountryCommandIndex {
  final CountryIndex _countryData;

  CountryCommandIndex(this._countryData);

  Future<dynamic> execute() async {
    try {
      var serviceResponse = await _countryData.fetchData();

      if (serviceResponse.statusCode == 200) {
        return CountriesModel.fromJson(serviceResponse.body);
      } else {
        return InternalServerError.fromServiceResponse(serviceResponse);
      }
    } on SocketException catch (e) {
      // Manejar errores de conexión
      return ApiError();
    } on FlutterError catch (flutterError) {
      // Manejar errores específicos de Flutter
      throw Exception(
          'Error en la aplicación Flutter: ${flutterError.message}');
    }
  }
}
