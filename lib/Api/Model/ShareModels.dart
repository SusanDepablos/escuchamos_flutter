import 'dart:convert';

SharesModel sharesModelFromJson(String str) => SharesModel.fromJson(json.decode(str));

String sharesModelToJson(SharesModel data) => json.encode(data.toJson());

class SharesModel {
    int count;
    dynamic next;
    dynamic previous;
    Results results;

    SharesModel({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    factory SharesModel.fromJson(Map<String, dynamic> json) => SharesModel(
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
    int userId;
    int postId;
    DateTime createdAt;
    DateTime updatedAt;

    DatumAttributes({
        required this.userId,
        required this.postId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory DatumAttributes.fromJson(Map<String, dynamic> json) => DatumAttributes(
        userId: json["user_id"],
        postId: json["post_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "post_id": postId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class DatumRelationships {
    User user;
    Post post;

    DatumRelationships({
        required this.user,
        required this.post,
    });

    factory DatumRelationships.fromJson(Map<String, dynamic> json) => DatumRelationships(
        user: User.fromJson(json["user"]),
        post: Post.fromJson(json["post"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "post": post.toJson(),
    };
}

class Post {
    int id;
    PostAttributes attributes;
    PostRelationships relationships;

    Post({
        required this.id,
        required this.attributes,
        required this.relationships,
    });

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        attributes: PostAttributes.fromJson(json["attributes"]),
        relationships: PostRelationships.fromJson(json["relationships"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
    };
}

class PostAttributes {
    String? body;
    dynamic postId;
    int userId;
    int statusId;
    int typePostId;
    DateTime createdAt;
    DateTime updatedAt;

    PostAttributes({
        this.body,
        required this.postId,
        required this.userId,
        required this.statusId,
        required this.typePostId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory PostAttributes.fromJson(Map<String, dynamic> json) => PostAttributes(
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

class PostRelationships {
    Post? post;
    User user;
    Status status;
    Status typePost;
    List<FileElement> files;
    List<dynamic> reactions;
    int reactionsCount;
    int commentsCount;
    int repostsCount;
    int sharesCount;
    int totalSharesCount;
    int reportsCount;

    PostRelationships({
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

    factory PostRelationships.fromJson(Map<String, dynamic> json) => PostRelationships(
        post: json["post"] == null ? null : Post.fromJson(json["post"]),
        user: User.fromJson(json["user"]),
        status: Status.fromJson(json["status"]),
        typePost: Status.fromJson(json["type_post"]),
        files: List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
        reactions: List<dynamic>.from(json["reactions"].map((x) => x)),
        reactionsCount: json["reactions_count"],
        commentsCount: json["comments_count"],
        repostsCount: json["reposts_count"],
        sharesCount: json["shares_count"],
        totalSharesCount: json["total_shares_count"],
        reportsCount: json["reports_count"],
    );

    Map<String, dynamic> toJson() => {
        "post": post,
        "user": user.toJson(),
        "status": status.toJson(),
        "type_post": typePost.toJson(),
        "files": List<dynamic>.from(files.map((x) => x)),
        "reactions": List<dynamic>.from(reactions.map((x) => x)),
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
    String description;
    DateTime createdAt;
    DateTime updatedAt;

    StatusAttributes({
        required this.name,
        required this.description,
        required this.createdAt,
        required this.updatedAt,
    });

    factory StatusAttributes.fromJson(Map<String, dynamic> json) => StatusAttributes(
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

