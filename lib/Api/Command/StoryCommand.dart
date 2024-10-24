//Flutter native support
import 'package:flutter/material.dart';
//Api support
import 'dart:io';
import 'package:escuchamos_flutter/Api/Service/StoryService.dart';
import 'package:escuchamos_flutter/Api/Model/StoryModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';

class StoryCommandIndex {
  final StoryIndex _storyData;
  final Map<String, String?>? filters;

  StoryCommandIndex(this._storyData, [this.filters]);

  Future<dynamic> execute() async {
    try {
      var response =
          await _storyData.fetchData(filters ?? {}); 

      if (response.statusCode == 200) {
        return StoriesModel.fromJson(response.body);
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

// class PostCommandCreate {
//   final PostCreate _postCreateService;

//   PostCommandCreate(this._postCreateService);

//   Future<dynamic> execute({
//     String? body, 
//     int? typePost, 
//     int? postId,
//     List<File>? files}) async {
//     try {
//       var response = await _postCreateService.createPost(
//         body: body,  
//         typePost: typePost,
//         postId: postId,
//         files: files,
//       );

//       if (response.statusCode == 201) {
//         return SuccessResponse.fromServiceResponse(response);
//       } else if (response.statusCode == 500) {
//         return InternalServerError.fromServiceResponse(response);
//       } else {
//         var content = response.body['validation'] ?? response.body['error'];
//         if (content is String) {
//           return SimpleErrorResponse.fromServiceResponse(response);
//         }
//         return ValidationResponse.fromServiceResponse(response);
//       }
//     } on SocketException catch (e) {
//       return ApiError();
//     } on FlutterError catch (flutterError) {
//       throw Exception(
//           'Error en la aplicación Flutter: ${flutterError.message}');
//     }
//   }
// }

class StoryGroupedCommandShow {
  final StoryGroupedShow _storyGroupedShowService;
  final int id;

  StoryGroupedCommandShow(this._storyGroupedShowService, this.id);

  Future<dynamic> execute() async {
    try {
      var response = await _storyGroupedShowService.showStoryGrouped(id);

      if (response.statusCode == 200) {
        return StoryGroupedModel.fromJson(response.body);
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


class StoryViewCommandPost {
  final StoryViewPost _storyViewService;

  StoryViewCommandPost(this._storyViewService);

  Future<dynamic> execute(
    int storyId
  ) async {
    try {
      var response = await _storyViewService.postStoryView(storyId);

      if (response.statusCode == 201) {
        return SuccessResponse.fromServiceResponse(response);
      } else if (response.statusCode == 204) {
        return 1;
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

// class PostCommandUpdate {
//   final PostUpdate _postUpdateService;

//   PostCommandUpdate(this._postUpdateService);

//   Future<dynamic> execute(
//       String bodyPost, int id) async {
//     try {
//       var response = await _postUpdateService.updatePost(
//           bodyPost, id);

//       if (response.statusCode == 200) {
//         return SuccessResponse.fromServiceResponse(response);
//       } else if (response.statusCode == 500) {
//         return InternalServerError.fromServiceResponse(response);
//       } else {
//         var content =
//             response.body['validation'] ?? response.body['error'];
//         if (content is String) {
//           return SimpleErrorResponse.fromServiceResponse(response);
//         }
//         return ValidationResponse.fromServiceResponse(response);
//       }
//     } on SocketException catch (e) {
//       return ApiError();
//     } on FlutterError catch (flutterError) {
//       throw Exception(
//           'Error en la aplicación Flutter: ${flutterError.message}');
//     }
//   }
// }

// class DeleteCommandPost {
//   final PostDelete _postDeleteService;

//   DeleteCommandPost(this._postDeleteService);

//   Future<dynamic> execute({required int id}) async {
//     try {
//       // Llamar a la función PostUpload con los parámetros file y type
//       var response = await _postDeleteService.deletePost(id);

//       // Manejar la respuesta según el código de estado
//       if (response.statusCode == 202) {
//         return SuccessResponse.fromServiceResponse(response);
//       } else if (response.statusCode == 500) {
//         return InternalServerError.fromServiceResponse(response);
//       } else {
//         var content = response.body['validation'] ?? response.body['error'];
//         if (content is String) {
//           return SimpleErrorResponse.fromServiceResponse(response);
//         }
//         return ValidationResponse.fromServiceResponse(response);
//       }
//     } on SocketException catch (e) {
//       return ApiError();
//     } on FlutterError catch (flutterError) {
//       throw Exception(
//           'Error en la aplicación Flutter: ${flutterError.message}');
//     }
//   }
// }
