import 'dart:convert';

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///MODELO DE FOLLOWS PARA INDEX
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FollowsModel followsModelFromJson(String str) => FollowsModel.fromJson(json.decode(str));

String followsModelToJson(FollowsModel data) => json.encode(data.toJson());

class FollowsModel {
    int count;
    dynamic next;
    dynamic previous;
    Results results;

    FollowsModel({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    factory FollowsModel.fromJson(Map<String, dynamic> json) => FollowsModel(
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
    List<Datum> data;

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
    int id;
    Attributes attributes;

    Datum({
        required this.id,
        required this.attributes,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
    };
}

class Attributes {
    FollowUser followingUser;
    FollowUser followedUser;
    DateTime createdAt;
    DateTime updatedAt;

    Attributes({
        required this.followingUser,
        required this.followedUser,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        followingUser: FollowUser.fromJson(json["following_user"]),
        followedUser: FollowUser.fromJson(json["followed_user"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "following_user": followingUser.toJson(),
        "followed_user": followedUser.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class FollowUser {
    int id;
    String username;
    String name;
    String? profilePhotoUrl;

    FollowUser({
        required this.id,
        required this.username,
        required this.name,
        this.profilePhotoUrl,
    });

    factory FollowUser.fromJson(Map<String, dynamic> json) => FollowUser(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        profilePhotoUrl: json["profile_photo_url"] as String?,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "profile_photo_url": profilePhotoUrl,
    };
}
