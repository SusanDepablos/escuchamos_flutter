import 'dart:convert';

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///MODELO DE PUBLICACIONES PARA SHOW
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
    Data data;

    PostModel({
        required this.data,
    });

    factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    int id;
    DataAttributes attributes;
    DatumRelationships relationships;

    Data({
        required this.id,
        required this.attributes,
        required this.relationships,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        attributes: DataAttributes.fromJson(json["attributes"]),
        relationships: DatumRelationships.fromJson(json["relationships"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
    };
}

class DataAttributes {
    String? body;
    dynamic postId;
    int userId;
    int statusId;
    int typePostId;
    DateTime createdAt;
    DateTime updatedAt;

    DataAttributes({
        this.body,
        required this.postId,
        required this.userId,
        required this.statusId,
        required this.typePostId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        body: json["body"] as String?,
        postId: json["post_id"],
        userId: json["user_id"],
        statusId: json["status_id"],
        typePostId: json["type_post_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "body": body,
        "post_id": postId,
        "user_id": userId,
        "status_id": statusId,
        "type_post_id": typePostId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///MODELO DE PUBLICACIONES PARA INDEX
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

PostsModel postsModelFromJson(String str) => PostsModel.fromJson(json.decode(str));

String postsModelToJson(PostsModel data) => json.encode(data.toJson());

class PostsModel {
    int count;
    dynamic next;
    dynamic previous;
    Results results;

    PostsModel({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    factory PostsModel.fromJson(Map<String, dynamic> json) => PostsModel(
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
    DatumRelationships relationships;

    Datum({
        required this.id,
        required this.attributes,
        required this.relationships,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        attributes: DatumAttributes.fromJson(json["attributes"]),
        relationships: DatumRelationships.fromJson(json["relationships"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
    };
}

class DatumAttributes {
    String? body;
    dynamic postId;
    int userId;
    int statusId;
    int typePostId;
    DateTime createdAt;
    DateTime updatedAt;

    DatumAttributes({
        this.body,
        required this.postId,
        required this.userId,
        required this.statusId,
        required this.typePostId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory DatumAttributes.fromJson(Map<String, dynamic> json) => DatumAttributes(
        body: json["body"] as String?,
        postId: json["post_id"],
        userId: json["user_id"],
        statusId: json["status_id"],
        typePostId: json["type_post_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "body": body,
        "post_id": postId,
        "user_id": userId,
        "status_id": statusId,
        "type_post_id": typePostId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///CLASES EN COMÚN
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class DatumRelationships {
    Datum? post;
    User user;
    Status status;
    Status typePost;
    List<FileElement> files;
    List<Reaction> reactions;
    int reactionsCount;
    int commentsCount;
    int repostsCount;
    int sharesCount;
    int totalSharesCount;
    int reportsCount;

    DatumRelationships({
        required this.post,
        required this.user,
        required this.status,
        required this.typePost,
        required this.files,
        required this.reactions,
        required this.reactionsCount,
        required this.commentsCount,
        required this.repostsCount,
        required this.sharesCount,
        required this.totalSharesCount,
        required this.reportsCount,
    });

    factory DatumRelationships.fromJson(Map<String, dynamic> json) => DatumRelationships(
        post: json["post"] == null ? null : Datum.fromJson(json["post"]),
        user: User.fromJson(json["user"]),
        status: Status.fromJson(json["status"]),
        typePost: Status.fromJson(json["type_post"]),
        files: List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
        reactions: List<Reaction>.from(json["reactions"].map((x) => Reaction.fromJson(x))),
        reactionsCount: json["reactions_count"],
        commentsCount: json["comments_count"],
        repostsCount: json["reposts_count"],
        sharesCount: json["shares_count"],
        totalSharesCount: json["total_shares_count"],
        reportsCount: json["reports_count"],
    );

    Map<String, dynamic> toJson() => {
        "post": post?.toJson(),
        "user": user.toJson(),
        "status": status.toJson(),
        "type_post": typePost.toJson(),
        "files": List<dynamic>.from(files.map((x) => x.toJson())),
        "reactions": List<dynamic>.from(reactions.map((x) => x.toJson())),
        "reactions_count": reactionsCount,
        "comments_count": commentsCount,
        "reposts_count": repostsCount,
        "shares_count": sharesCount,
        "total_shares_count": totalSharesCount,
        "reports_count": reportsCount,
    };
}


class User {
    int id;
    String username;
    String name;
    String? profilePhotoUrl;

    User({
        required this.id,
        required this.username,
        required this.name,
        this.profilePhotoUrl,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
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

class Status {
    int id;
    StatusAttributes attributes;

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
    String name;
    String? description;
    DateTime createdAt;
    DateTime updatedAt;

    StatusAttributes({
        required this.name,
        this.description,
        required this.createdAt,
        required this.updatedAt,
    });

    factory StatusAttributes.fromJson(Map<String, dynamic> json) => StatusAttributes(
        name: json["name"],
        description: json["description"] as String?,
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

class Reaction {
    int id;
    ReactionAttributes attributes;
    ReactionRelationships relationships;

    Reaction({
        required this.id,
        required this.attributes,
        required this.relationships,
    });

    factory Reaction.fromJson(Map<String, dynamic> json) => Reaction(
        id: json["id"],
        attributes: ReactionAttributes.fromJson(json["attributes"]),
        relationships: ReactionRelationships.fromJson(json["relationships"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
    };
}

class ReactionAttributes {
    int contentType;
    int objectId;
    int userId;
    DateTime createdAt;
    DateTime updatedAt;

    ReactionAttributes({
        required this.contentType,
        required this.objectId,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory ReactionAttributes.fromJson(Map<String, dynamic> json) => ReactionAttributes(
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

class ReactionRelationships {
    User user;

    ReactionRelationships({
        required this.user,
    });

    factory ReactionRelationships.fromJson(Map<String, dynamic> json) => ReactionRelationships(
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
    };
}
