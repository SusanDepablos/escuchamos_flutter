// To parse this JSON data, do
//
//     final reactionsModel = reactionsModelFromJson(jsonString);

import 'dart:convert';

ReactionsModel reactionsModelFromJson(String str) =>
    ReactionsModel.fromJson(json.decode(str));

String reactionsModelToJson(ReactionsModel data) => json.encode(data.toJson());

class ReactionsModel {
  final int count;
  final String next;
  final dynamic previous;
  final Results results;

  ReactionsModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory ReactionsModel.fromJson(Map<String, dynamic> json) => ReactionsModel(
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
  final Attributes attributes;
  final Relationships relationships;

  Datum({
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
        relationships: Relationships.fromJson(json["relationships"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
      };
}

class Attributes {
  final int contentType;
  final int objectId;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Attributes({
    required this.contentType,
    required this.objectId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        contentType: json["content_type"],
        objectId: json["object_id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "content_type": contentType,
        "object_id": objectId,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Relationships {
  final User user;

  Relationships({
    required this.user,
  });

  factory Relationships.fromJson(Map<String, dynamic> json) => Relationships(
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
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
