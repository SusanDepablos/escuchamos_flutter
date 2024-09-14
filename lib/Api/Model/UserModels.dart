import 'dart:convert';

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///MODELO DE USUARIOS PARA SHOW
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    Data data;

    UserModel({
        required this.data,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///MODELO DE USUARIOS PARA INDEX
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

UsersModel usersModelFromJson(String str) => UsersModel.fromJson(json.decode(str));

String usersModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
    int count;
    dynamic next;
    dynamic previous;
    Results results;

    UsersModel({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
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
    DatumAttributes attributes;
    Relationships relationships;

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
    String username;
    String name;
    String email;
    String? biography;
    String? phoneNumber;
    DateTime? birthdate;
    dynamic countryId;
    DateTime createdAt;
    DateTime updatedAt;

    DatumAttributes({
        required this.username,
        required this.name,
        required this.email,
        this.biography,
        this.phoneNumber,
        this.birthdate,
        required this.countryId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory DatumAttributes.fromJson(Map<String, dynamic> json) => DatumAttributes(
        username: json["username"],
        name: json["name"],
        email: json["email"],
        biography: json["biography"] as String?,
        phoneNumber: json["phone_number"] as String?,
        birthdate: json["birthdate"] != null ? DateTime.parse(json["birthdate"]) : null,
        countryId: json["country_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "name": name,
        "email": email,
        "biography": biography,
        "phone_number": phoneNumber,
        "birthdate": birthdate != null ? "${birthdate!.year.toString().padLeft(4, '0')}-${birthdate!.month.toString().padLeft(2, '0')}-${birthdate!.day.toString().padLeft(2, '0')}" : null,
        "country_id": countryId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class Data {
    int id;
    DataAttributes attributes;
    Relationships relationships;

    Data({
        required this.id,
        required this.attributes,
        required this.relationships,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        attributes: DataAttributes.fromJson(json["attributes"]),
        relationships: Relationships.fromJson(json["relationships"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
    };
}

class DataAttributes {
    String username;
    String name;
    String email;
    String? biography;
    String? phoneNumber;
    DateTime? birthdate;
    dynamic countryId;
    DateTime createdAt;
    DateTime updatedAt;

    DataAttributes({
        required this.username,
        required this.name,
        required this.email,
        this.biography,
        this.phoneNumber,
        this.birthdate,
        required this.countryId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        username: json["username"],
        name: json["name"],
        email: json["email"],
        biography: json["biography"] as String?,
        phoneNumber: json["phone_number"] as String?,
        birthdate: json["birthdate"]!= null ? DateTime.parse(json["birthdate"]) : null,
        countryId: json["country_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "name": name,
        "email": email,
        "biography": biography,
        "phone_number": phoneNumber,
        "birthdate": birthdate != null ? "${birthdate!.year.toString().padLeft(4, '0')}-${birthdate!.month.toString().padLeft(2, '0')}-${birthdate!.day.toString().padLeft(2, '0')}" : null,
        "country_id": countryId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///CLASES EN COMÚN
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Relationships {
    Country? country;
    List<Group> groups;
    List<FileElement> files;
    int followingCount;
    int followersCount;
    List<Follow> following;
    List<Follow> followers;

    Relationships({
        this.country,
        required this.groups,
        required this.files,
        required this.followingCount,
        required this.followersCount,
        required this.following,
        required this.followers,
    });

    factory Relationships.fromJson(Map<String, dynamic> json) => Relationships(
        country: json["country"] != null ? Country.fromJson(json["country"]) : null,
        groups: List<Group>.from(json["groups"].map((x) => Group.fromJson(x))),
        files: List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
        followingCount: json["following_count"],
        followersCount: json["followers_count"],
        following: List<Follow>.from(json["following"].map((x) => Follow.fromJson(x))),
        followers: List<Follow>.from(json["followers"].map((x) => Follow.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "country": country?.toJson(), 
        "groups": List<dynamic>.from(groups.map((x) => x.toJson())),
        "files": List<dynamic>.from(files.map((x) => x.toJson())),
        "following_count": followingCount,
        "followers_count": followersCount,
        "following": List<dynamic>.from(following.map((x) => x.toJson())),
        "followers": List<dynamic>.from(followers.map((x) => x.toJson())),
    };
}

class Country {
    int id;
    CountryAttributes attributes;

    Country({
        required this.id,
        required this.attributes,
    });

    factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        attributes: CountryAttributes.fromJson(json["attributes"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
    };
}

class CountryAttributes {
    String name;
    String? abbreviation;
    String? dialingCode;
    String? iso;
    DateTime createdAt;
    DateTime updatedAt;

    CountryAttributes({
        required this.name,
        this.abbreviation,
        this.dialingCode,
        this.iso,
        required this.createdAt,
        required this.updatedAt,
    });

    factory CountryAttributes.fromJson(Map<String, dynamic> json) => CountryAttributes(
        name: json["name"],
        abbreviation: json["abbreviation"],
        dialingCode: json["dialing_code"],
        iso: json["iso"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "abbreviation": abbreviation,
        "dialing_code": dialingCode,
        "iso": iso,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class FileElement {
    int id;
    FileAttributes attributes;

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

class Group {
    int id;
    GroupAttributes attributes;

    Group({
        required this.id,
        required this.attributes,
    });

    factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"],
        attributes: GroupAttributes.fromJson(json["attributes"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
    };
}

class GroupAttributes {
    String name;

    GroupAttributes({
        required this.name,
    });

    factory GroupAttributes.fromJson(Map<String, dynamic> json) => GroupAttributes(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}

class Follow {
    int id;
    FollowerAttributes attributes;

    Follow({
        required this.id,
        required this.attributes,
    });

    factory Follow.fromJson(Map<String, dynamic> json) => Follow(
        id: json["id"],
        attributes: FollowerAttributes.fromJson(json["attributes"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
    };
}

class FollowerAttributes {
    FollowUser followingUser;
    FollowUser followedUser;
    DateTime createdAt;
    DateTime updatedAt;

    FollowerAttributes({
        required this.followingUser,
        required this.followedUser,
        required this.createdAt,
        required this.updatedAt,
    });

    factory FollowerAttributes.fromJson(Map<String, dynamic> json) => FollowerAttributes(
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
        profilePhotoUrl
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
