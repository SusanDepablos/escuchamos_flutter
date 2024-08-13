//Api support
import 'dart:convert';

class ServiceResponse {
  final Map<String, dynamic> body; // Contenido de la respuesta
  final int statusCode; // Código de estado HTTP

  ServiceResponse(this.body, this.statusCode);

  factory ServiceResponse.fromJsonString(String jsonString, int statusCode) {
    // Deserializa la cadena JSON directamente en el constructor
    return ServiceResponse(jsonDecode(jsonString), statusCode);
  }
}
