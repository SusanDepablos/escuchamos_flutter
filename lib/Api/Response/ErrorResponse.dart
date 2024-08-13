//Flutter native support
import 'package:escuchamos_flutter/Api/Response/ServiceResponse.dart';

class SimpleErrorResponse {
  final Map<String, dynamic> body;
  final int statusCode;

  SimpleErrorResponse({
    required this.body,
    required this.statusCode,
  });

  factory SimpleErrorResponse.fromServiceResponse(ServiceResponse ServiceResponse) {
    return SimpleErrorResponse(
      body: ServiceResponse.body,
      statusCode: ServiceResponse.statusCode,
    );
  }

String get message {
    if (body.containsKey('validation')) {
      return body['validation'] as String;
    }
    return body['error'] as String; // O lanza un error si la clave debe existir
  }

  @override
  String toString() {
    return 'StatusCode: $statusCode, Message: $message';
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class ValidationResponse {
  final Map<String, String> key;

  ValidationResponse({required this.key});

  factory ValidationResponse.fromServiceResponse(
      ServiceResponse serviceResponse) {
    final validationData = serviceResponse.body['validation'];
    final Map<String, String> errors = {};

    if (validationData is Map<String, dynamic>) {
      validationData.forEach((fieldName, messages) {
        if (messages is List) {
          errors[fieldName] = messages.isNotEmpty ? messages[0] : '';
        }
      });
    }

    return ValidationResponse(key: errors);
  }

  String? message(String fieldName) {
    return key[fieldName];
  }
}

class ApiError {
  final String message;

  ApiError() : message = 'Sin conexión a la API.';

  @override
  String toString() {
    return 'Message: $message';
  }
}



