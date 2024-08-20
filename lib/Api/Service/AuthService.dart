import 'package:http/http.dart' as http;
import 'package:escuchamos_flutter/Api/Response/ServiceResponse.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:convert';

class UserLogin {
  Future<ServiceResponse> loginUser(String username, String password) async {
    // Define el URL al que se enviará la solicitud POST
    final url = Uri.parse('${ApiUrl.baseUrl}login/');

    // Define el cuerpo de la solicitud POST
    final body = jsonEncode({
      'username': username,
      'password': password,
    });

    // Define las cabeceras para la solicitud
    final headers = {
      'Content-Type': 'application/json',
    };

    // Realiza la solicitud POST
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    // Retorna la respuesta de la API envuelta en ServiceResponse
    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }

}

class UserLogout {
  Future<ServiceResponse> logoutUser(String token) async {
    // Define el URL al que se enviará la solicitud POST
    final url = Uri.parse('${ApiUrl.baseUrl}logout/');

    // Define las cabeceras para la solicitud POST, incluyendo el token
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token', // Añadir el token en las cabeceras
    };

    // Realiza la solicitud POST
    final response = await http.post(
      url,
      headers: headers,
    );

    // Retorna la respuesta de la API envuelta en ServiceResponse
    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }
}



class UserRegister {
  Future<ServiceResponse> registerUser(String name, String username, String password, String email, String birthdate) async {
    // Define el URL al que se enviará la solicitud POST
    final url = Uri.parse('${ApiUrl.baseUrl}register/');

    // Define el cuerpo de la solicitud POST
    final body = jsonEncode({
      'name': name,
      'username': username,
      'password': password,
      'email': email,
      'birthdate': birthdate,
    });



    // Define las cabeceras para la solicitud
    final headers = {
      'Content-Type': 'application/json',
    };

    // Realiza la solicitud POST
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    // Retorna la respuesta de la API envuelta en ServiceResponse
    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }

}

class UserVerifycode {
  Future<ServiceResponse> verifycodeUser(String verificationcode, String useremail) async {
    // Define el URL al que se enviará la solicitud POST
    final url = Uri.parse('${ApiUrl.baseUrl}email/verification/');

    // Define el cuerpo de la solicitud POST
    final body = jsonEncode({
      'verification_code': verificationcode,
      'user_email': useremail,
    });


    // Define las cabeceras para la solicitud
    final headers = {
      'Content-Type': 'application/json',
    };

    // Realiza la solicitud POST
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    // Retorna la respuesta de la API envuelta en ServiceResponse
    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }

}

class ResendCode {
  Future<ServiceResponse> resendcodeUser(String useremail) async {
    // Define el URL al que se enviará la solicitud POST
    final url = Uri.parse('${ApiUrl.baseUrl}resend/verification/code/');

    // Define el cuerpo de la solicitud POST
    final body = jsonEncode({
      'user_email': useremail,
    });


    // Define las cabeceras para la solicitud
    final headers = {
      'Content-Type': 'application/json',
    };

    // Realiza la solicitud POST
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    // Retorna la respuesta de la API envuelta en ServiceResponse
    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }

}