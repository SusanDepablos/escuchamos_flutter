import 'dart:convert';

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
    String? birthdate;
    int? countryId;
    DateTime createdAt;
    DateTime updatedAt;

    DataAttributes({
        required this.username,
        required this.name,
        required this.email,
        this.biography,
        this.phoneNumber,
        this.birthdate,
        this.countryId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        username: json["username"],
        name: json["name"],
        email: json["email"],
        biography: json["biography"],
        phoneNumber: json["phone_number"],
        birthdate: json["birthdate"],
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
        "birthdate": birthdate,
        "country_id": countryId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class Relationships {
    Country? country;
    List<Group> groups;
    List<FileElement> files;
    int followingCount;
    int followersCount;

    Relationships({
        this.country,
        required this.groups,
        required this.files,
        required this.followingCount,
        required this.followersCount,
    });

    factory Relationships.fromJson(Map<String, dynamic> json) => Relationships(
        country: json["country"] != null ? Country.fromJson(json["country"]) : null,
        groups: List<Group>.from(json["groups"].map((x) => Group.fromJson(x))),
        files: List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
        followingCount: json["following_count"],
        followersCount: json["followers_count"],
    );

    Map<String, dynamic> toJson() => {
        "country": country?.toJson(), 
        "groups": List<dynamic>.from(groups.map((x) => x.toJson())),
        "files": List<dynamic>.from(files.map((x) => x.toJson())),
        "following_count": followingCount,
        "followers_count": followersCount,
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
    DateTime createdAt;
    DateTime updatedAt;

    CountryAttributes({
        required this.name,
        this.abbreviation,
        this.dialingCode,
        required this.createdAt,
        required this.updatedAt,
    });

    factory CountryAttributes.fromJson(Map<String, dynamic> json) => CountryAttributes(
        name: json["name"],
        abbreviation: json["abbreviation"],
        dialingCode: json["dialing_code"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "abbreviation": abbreviation,
        "dialing_code": dialingCode,
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
