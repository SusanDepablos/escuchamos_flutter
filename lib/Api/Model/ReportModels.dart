import 'dart:convert';

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///MODELO DE REPORTES USUARIOS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ReportsModel reportsModelFromJson(String str) => ReportsModel.fromJson(json.decode(str));

String reportsModelToJson(ReportsModel data) => json.encode(data.toJson());

class ReportsModel {
    int count;
    dynamic next;
    dynamic previous;
    ReportsResults results;

    ReportsModel({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    factory ReportsModel.fromJson(Map<String, dynamic> json) => ReportsModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: ReportsResults.fromJson(json["results"]),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results.toJson(),
    };
}

class ReportsResults {
    List<ReportsDatum> data;

    ReportsResults({
        required this.data,
    });

    factory ReportsResults.fromJson(Map<String, dynamic> json) => ReportsResults(
        data: List<ReportsDatum>.from(json["data"].map((x) => ReportsDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ReportsDatum {
    int id;
    Attributes attributes;
    Relationships relationships;

    ReportsDatum({
        required this.id,
        required this.attributes,
        required this.relationships,
    });

    factory ReportsDatum.fromJson(Map<String, dynamic> json) => ReportsDatum(
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
    int contentType;
    int objectId;
    String observation;
    int userId;
    DateTime createdAt;
    DateTime updatedAt;

    Attributes({
        required this.contentType,
        required this.objectId,
        required this.observation,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        contentType: json["content_type"],
        objectId: json["object_id"],
        observation: json["observation"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "content_type": contentType,
        "object_id": objectId,
        "observation": observation,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class Relationships {
    User user;

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///MODELO DE REPORTES AGRUPADOS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ReportsGroupedModel reportsGroupedModelFromJson(String str) => ReportsGroupedModel.fromJson(json.decode(str));

String reportsGroupedModelToJson(ReportsGroupedModel data) => json.encode(data.toJson());

class ReportsGroupedModel {
    int count;
    dynamic next;
    dynamic previous;
    Results results;

    ReportsGroupedModel({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    factory ReportsGroupedModel.fromJson(Map<String, dynamic> json) => ReportsGroupedModel(
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
    DatumAttributes attributes;
    DatumRelationships relationships;

    Datum({
        required this.attributes,
        required this.relationships,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        attributes: DatumAttributes.fromJson(json["attributes"]),
        relationships: DatumRelationships.fromJson(json["relationships"]),
    );

    Map<String, dynamic> toJson() => {
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
    };
}

class DatumAttributes {
    int contentType;
    int objectId;
    int reportsCount;

    DatumAttributes({
        required this.contentType,
        required this.objectId,
        required this.reportsCount,
    });

    factory DatumAttributes.fromJson(Map<String, dynamic> json) => DatumAttributes(
        contentType: json["content_type"],
        objectId: json["object_id"],
        reportsCount: json["reports_count"],
    );

    Map<String, dynamic> toJson() => {
        "content_type": contentType,
        "object_id": objectId,
        "reports_count": reportsCount,
    };
}

class DatumRelationships {
    Post? post;
    Comment? comment;

    DatumRelationships({
        required this.post,
        required this.comment,
    });

    factory DatumRelationships.fromJson(Map<String, dynamic> json) => DatumRelationships(
        post: json["post"] == null ? null : Post.fromJson(json["post"]),
        comment: json["comment"] == null ? null : Comment.fromJson(json["comment"]),
    );

    Map<String, dynamic> toJson() => {
        "post": post?.toJson(),
        "comment": comment?.toJson(),
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
    List<Reaction> reactions;
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
        reactions: List<Reaction>.from(json["reactions"].map((x) => Reaction.fromJson(x))),
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

class Comment {
    int id;
    CommentAttributes attributes;
    CommentRelationships relationships;

    Comment({
        required this.id,
        required this.attributes,
        required this.relationships,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        attributes: CommentAttributes.fromJson(json["attributes"]),
        relationships: CommentRelationships.fromJson(json["relationships"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
    };
}

class CommentAttributes {
    String? body;
    int statusId;
    int? postId;
    int userId;
    dynamic commentId;
    DateTime createdAt;
    DateTime updatedAt;

    CommentAttributes({
        this.body,
        required this.statusId,
        required this.postId,
        required this.userId,
        required this.commentId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory CommentAttributes.fromJson(Map<String, dynamic> json) => CommentAttributes(
        body: json["body"] as String?,
        statusId: json["status_id"],
        postId: json["post_id"],
        userId: json["user_id"],
        commentId: json["comment_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"])
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

class CommentRelationships {
    User user;
    Status status;
    List<FileElement> file;
    List<Reaction> reactions;
    int repliesCount;
    int reactionsCount;
    int reportsCount;

    CommentRelationships({
        required this.user,
        required this.status,
        required this.file,
        required this.reactions,
        required this.repliesCount,
        required this.reactionsCount,
        required this.reportsCount,
    });

    factory CommentRelationships.fromJson(Map<String, dynamic> json) => CommentRelationships(
        user: User.fromJson(json["user"]),
        status: Status.fromJson(json["status"]),
        file: List<FileElement>.from(json["file"].map((x) => FileElement.fromJson(x))),
        reactions: List<Reaction>.from(json["reactions"].map((x) => Reaction.fromJson(x))),
        repliesCount: json["replies_count"],
        reactionsCount: json["reactions_count"],
        reportsCount: json["reports_count"],
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "status": status.toJson(),
        "file": List<dynamic>.from(file.map((x) => x.toJson())),
        "reactions": List<dynamic>.from(reactions.map((x)  => x.toJson())),
        "replies_count": repliesCount,
        "reactions_count": reactionsCount,
        "reports_count": reportsCount,
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
        description: json["description"] as String,
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
    int id;
    String username;
    String name;
    String? profilePhotoUrl;
    List<int>? groupId;

    User({
        required this.id,
        required this.username,
        required this.name,
        this.profilePhotoUrl,
        this.groupId,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        profilePhotoUrl: json["profile_photo_url"] as String?,
        groupId: json["group_id"] == null ? [] : List<int>.from(json["group_id"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "profile_photo_url": profilePhotoUrl,
        "group_id": groupId == null ? [] : List<dynamic>.from(groupId!.map((x) => x)),
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
