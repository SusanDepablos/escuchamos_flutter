import 'dart:convert';

NorificationsModel norificationsModelFromJson(String str) => NorificationsModel.fromJson(json.decode(str));

String norificationsModelToJson(NorificationsModel data) => json.encode(data.toJson());

class NorificationsModel {
    int count;
    dynamic next;
    dynamic previous;
    Results results;

    NorificationsModel({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    factory NorificationsModel.fromJson(Map<String, dynamic> json) => NorificationsModel(
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
    int contentType;
    String modelName;
    int objectId;
    int? userId;
    int? receiverUserId;
    String message;
    String type;
    bool isRead;
    bool isSeen;
    DateTime createdAt;
    DateTime updatedAt;

    DatumAttributes({
        required this.contentType,
        required this.modelName,
        required this.objectId,
        this.userId,
        this.receiverUserId,
        required this.message,
        required this.type,
        required this.isRead,
        required this.isSeen,
        required this.createdAt,
        required this.updatedAt,
    });

    factory DatumAttributes.fromJson(Map<String, dynamic> json) => DatumAttributes(
        contentType: json["content_type"],
        modelName: json["model_name"],
        objectId: json["object_id"],
        userId: json["user_id"],
        receiverUserId: json["receiver_user_id"],
        message: json["message"],
        type: json["type"],
        isRead: json["is_read"],
        isSeen: json["is_seen"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "content_type": contentType,
        "model_name": modelName,
        "object_id": objectId,
        "user_id": userId,
        "receiver_user_id": receiverUserId,
        "message": message,
        "type": type,
        "is_read": isRead,
        "is_seen": isSeen,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class DatumRelationships {
    User user;
    User receiverUser;
    Comment comment;
    Reaction reaction;
    Comment share;

    DatumRelationships({
        required this.user,
        required this.receiverUser,
        required this.comment,
        required this.reaction,
        required this.share,
    });

    factory DatumRelationships.fromJson(Map<String, dynamic> json) => DatumRelationships(
        user: User.fromJson(json["user"]),
        receiverUser: User.fromJson(json["receiver_user"]),
        comment: Comment.fromJson(json["comment"]),
        reaction: Reaction.fromJson(json["reaction"]),
        share: Comment.fromJson(json["share"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "receiver_user": receiverUser.toJson(),
        "comment": comment.toJson(),
        "reaction": reaction.toJson(),
        "share": share.toJson(),
    };
}

class Comment {
    int id;
    CommentAttributes attributes;

    Comment({
        required this.id,
        required this.attributes,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        attributes: CommentAttributes.fromJson(json["attributes"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
    };
}

class CommentAttributes {
    int postId;
    int userId;
    dynamic commentId;
    DateTime createdAt;
    DateTime updatedAt;

    CommentAttributes({
        required this.postId,
        required this.userId,
        this.commentId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory CommentAttributes.fromJson(Map<String, dynamic> json) => CommentAttributes(
        postId: json["post_id"],
        userId: json["user_id"],
        commentId: json["comment_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "post_id": postId,
        "user_id": userId,
        "comment_id": commentId,
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
        groupId: List<int>.from(json["group_id"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "profile_photo_url": profilePhotoUrl,
        "group_id": List<dynamic>.from(groupId!.map((x) => x)),
    };
}