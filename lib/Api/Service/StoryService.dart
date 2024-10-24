import 'package:http/http.dart' as http;
import 'package:escuchamos_flutter/Api/Response/ServiceResponse.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage _storage = FlutterSecureStorage();

class StoryIndex {
  Future<ServiceResponse> fetchData(Map<String, String?> filters) async {

    var uri = Uri.parse('${ApiUrl.baseUrl}story/');
    final token = await _storage.read(key: 'token') ?? '';

    if (filters.isNotEmpty) {
      final queryString = filters.entries
          .where((entry) => entry.value != null && entry.value!.isNotEmpty)
          .map((entry) => '${entry.key}=${entry.value}')
          .join('&');

      if (queryString.isNotEmpty) {
        uri = uri.replace(query: queryString);
      }
    }

    // Define los encabezados
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    // Realiza la solicitud con encabezados
    var response = await http.get(uri, headers: headers);

    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }
}

// class StoryCreate {
//   Future<ServiceResponse> createStory({
//     String? body,
//     int? typePost,
//     int? postId,
//     List<File>? files,
//     }) async {

//     final url = Uri.parse('${ApiUrl.baseUrl}post/');
//     final token = await _storage.read(key: 'token') ?? '';

//     final headers = {
//         'Authorization': 'Token $token',
//       };

//       // Crear una solicitud multipart
//       var request = http.MultipartRequest('POST', url);
//       request.headers.addAll(headers);

//       // Adjuntar múltiples archivos al cuerpo del formulario bajo el mismo campo 'file'
//       if (files != null) {
//         for (var file in files) {
//           request.files.add(await http.MultipartFile.fromPath('file', file.path));
//         }
//       }

//       // Agregar otros campos solo si no son nulos
//       if (body != null && body.isNotEmpty) {
//         request.fields['body'] = body;
//       }

//       if (postId != null && postId.toString().isNotEmpty) {
//         request.fields['post_id'] = postId.toString();
//       }
//       request.fields['type_post_id'] = typePost.toString(); 

//     final streamedResponse = await request.send();

//     final response = await http.Response.fromStream(streamedResponse);
//     return ServiceResponse.fromJsonString(
//       utf8.decode(response.bodyBytes),
//       response.statusCode,
//     );
//   }
// }

class StoryGroupedShow {
  Future<ServiceResponse> showStoryGrouped(int id) async {
    final url = Uri.parse('${ApiUrl.baseUrl}story/grouped/$id/');
    final token = await _storage.read(key: 'token') ?? '';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }
}

class StoryViewPost {
  Future<ServiceResponse> postStoryView(
      int storyId) async {
    final url = Uri.parse('${ApiUrl.baseUrl}story-view/');
    final token = await _storage.read(key: 'token') ?? '';

    final body = jsonEncode({
      'story_id': storyId,
    });

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 204) {
      // No hay contenido, devuelve un objeto ServiceResponse vacío o similar
      return ServiceResponse.fromJsonString('{}', response.statusCode);
    }

    return ServiceResponse.fromJsonString(
      utf8.decode(response.bodyBytes),
      response.statusCode,
    );
  }
}

// class PostUpdate {
//   Future<ServiceResponse> updatePost(String bodyPost, int id) async {
//     // Define el URL al que se enviará la solicitud POST
//     final url = Uri.parse('${ApiUrl.baseUrl}post/$id/');
//     final token = await _storage.read(key: 'token') ?? '';

//     // Define el cuerpo de la solicitud POST
//     final body = jsonEncode({
//       'body': bodyPost.isNotEmpty ? bodyPost : '',
//     });
//     // Define las cabeceras para la solicitud
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Token $token', // Añadir el token en las cabeceras
//     };

//     final response = await http.put(
//       url,
//       headers: headers,
//       body: body,
//     );

//     return ServiceResponse.fromJsonString(
//       utf8.decode(response.bodyBytes),
//       response.statusCode,
//     );
//   }
// }

// class PostDelete {
//   Future<ServiceResponse> deletePost(int id) async {
//     // Define el URL al que se enviará la solicitud POST
//     final url = Uri.parse('${ApiUrl.baseUrl}post/$id/');
//     final token = await _storage.read(key: 'token') ?? '';


//     // Define las cabeceras para la solicitud
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Token $token', // Añadir el token en las cabeceras
//     };

//     final response = await http.delete(
//       url,
//       headers: headers,
//     );

//     return ServiceResponse.fromJsonString(
//       utf8.decode(response.bodyBytes),
//       response.statusCode,
//     );
//   }
// }
