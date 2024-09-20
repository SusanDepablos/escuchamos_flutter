// To parse this JSON data, do
//
//     final commentsModel = commentsModelFromJson(jsonString);

import 'dart:convert';

CommentsModel commentsModelFromJson(String str) =>
    CommentsModel.fromJson(json.decode(str));

String commentsModelToJson(CommentsModel data) => json.encode(data.toJson());

class CommentsModel {
  final int count;
  final dynamic next;
  final dynamic previous;
  final Results results;

  CommentsModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory CommentsModel.fromJson(Map<String, dynamic> json) => CommentsModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: Results.fromJson(json["results"]),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results.toJson(),
      };
}

class Results {
  final List<Datum> data;

  Results({
    required this.data,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  final int id;
  final DatumAttributes attributes;
  final Relationships relationships;

  Datum({
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        attributes: DatumAttributes.fromJson(json["attributes"]),
        relationships: Relationships.fromJson(json["relationships"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
      };
}

class DatumAttributes {
  final String? body;
  final int statusId;
  final int postId;
  final int userId;
  final dynamic commentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  DatumAttributes({
    this.body,
    required this.statusId,
    required this.postId,
    required this.userId,
    required this.commentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DatumAttributes.fromJson(Map<String, dynamic> json) =>
      DatumAttributes(
        body: json["body"] as String?,
        statusId: json["status_id"],
        postId: json["post_id"],
        userId: json["user_id"],
        commentId: json["comment_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "body": body,
        "status_id": statusId,
        "post_id": postId,
        "user_id": userId,
        "comment_id": commentId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Relationships {
  final User user;
  final Status status;
  final List<FileElement> file;
  final List<dynamic> reactions;
  final int repliesCount;
  final int reactionsCount;
  final int reportsCount;

  Relationships({
    required this.user,
    required this.status,
    required this.file,
    required this.reactions,
    required this.repliesCount,
    required this.reactionsCount,
    required this.reportsCount,
  });

  factory Relationships.fromJson(Map<String, dynamic> json) => Relationships(
        user: User.fromJson(json["user"]),
        status: Status.fromJson(json["status"]),
        file: List<FileElement>.from(
            json["file"].map((x) => FileElement.fromJson(x))),
        reactions: List<dynamic>.from(json["reactions"].map((x) => x)),
        repliesCount: json["replies_count"],
        reactionsCount: json["reactions_count"],
        reportsCount: json["reports_count"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "status": status.toJson(),
        "file": List<dynamic>.from(file.map((x) => x.toJson())),
        "reactions": List<dynamic>.from(reactions.map((x) => x)),
        "replies_count": repliesCount,
        "reactions_count": reactionsCount,
        "reports_count": reportsCount,
      };
}

class FileElement {
  final int id;
  final FileAttributes attributes;

  FileElement({
    required this.id,
    required this.attributes,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        id: json["id"],
        attributes: FileAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class FileAttributes {
  int contentType;
  int objectId;
  String path;
  String extension;
  String size;
  String type;
  String url;
  DateTime createdAt;
  DateTime updatedAt;

  FileAttributes({
    required this.contentType,
    required this.objectId,
    required this.path,
    required this.extension,
    required this.size,
    required this.type,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FileAttributes.fromJson(Map<String, dynamic> json) => FileAttributes(
        contentType: json["content_type"],
        objectId: json["object_id"],
        path: json["path"],
        extension: json["extension"],
        size: json["size"],
        type: json["type"],
        url: json["url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "content_type": contentType,
        "object_id": objectId,
        "path": path,
        "extension": extension,
        "size": size,
        "type": type,
        "url": url,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Status {
  final int id;
  final StatusAttributes attributes;

  Status({
    required this.id,
    required this.attributes,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"],
        attributes: StatusAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class StatusAttributes {
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  StatusAttributes({
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StatusAttributes.fromJson(Map<String, dynamic> json) =>
      StatusAttributes(
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class User {
  final int id;
  final String username;
  final String name;
  final String? profilePhotoUrl;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.profilePhotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        profilePhotoUrl: json["profile_photo_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "profile_photo_url": profilePhotoUrl,
      };
}
