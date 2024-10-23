import 'dart:convert';

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///MODELO DE STORIES PARA INDEX
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

StoriesModel storiesModelFromJson(String str) => StoriesModel.fromJson(json.decode(str));

String storiesModelToJson(StoriesModel data) => json.encode(data.toJson());

class StoriesModel {
    int count;
    dynamic next;
    dynamic previous;
    Results results;

    StoriesModel({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    factory StoriesModel.fromJson(Map<String, dynamic> json) => StoriesModel(
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///MODELO DE STORY PARA SHOW AGRUPADO
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

StoryGroupedModel storyGroupedModelFromJson(String str) => StoryGroupedModel.fromJson(json.decode(str));

String storyGroupedModelToJson(StoryGroupedModel data) => json.encode(data.toJson());

class StoryGroupedModel {
    Datum data;

    StoryGroupedModel({
        required this.data,
    });

    factory StoryGroupedModel.fromJson(Map<String, dynamic> json) => StoryGroupedModel(
        data: Datum.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///CLASES EN COMÚN
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
    User user;
    List<Story> stories;
    bool allRead;

    Datum({
        required this.user,
        required this.stories,
        required this.allRead,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        user: User.fromJson(json["user"]),
        stories: List<Story>.from(json["stories"].map((x) => Story.fromJson(x))),
        allRead: json["all_read"],
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "stories": List<dynamic>.from(stories.map((x) => x.toJson())),
        "all_read": allRead,
    };
}

class Story {
    int id;
    StoryAttributes attributes;
    Relationships relationships;
    bool isRead;

    Story({
        required this.id,
        required this.attributes,
        required this.relationships,
        required this.isRead,
    });

    factory Story.fromJson(Map<String, dynamic> json) => Story(
        id: json["id"],
        attributes: StoryAttributes.fromJson(json["attributes"]),
        relationships: Relationships.fromJson(json["relationships"]),
        isRead: json["is_read"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
        "relationships": relationships.toJson(),
        "is_read": isRead,
    };
}

class StoryAttributes {
    String? content;
    bool archive;
    int userId;
    int statusId;
    dynamic postId;
    DateTime createdAt;
    DateTime updatedAt;

    StoryAttributes({
        required this.content,
        required this.archive,
        required this.userId,
        required this.statusId,
        required this.postId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory StoryAttributes.fromJson(Map<String, dynamic> json) => StoryAttributes(
        content: json["content"],
        archive: json["archive"],
        userId: json["user_id"],
        statusId: json["status_id"],
        postId: json["post_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "content": content,
        "archive": archive,
        "user_id": userId,
        "status_id": statusId,
        "post_id": postId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class Relationships {
    Status status;
    Post? post;
    List<FileElement> file;
    List<Reaction> reactions;
    int reactionsCount;
    int reportsCount;

    Relationships({
        required this.status,
        required this.post,
        required this.file,
        required this.reactions,
        required this.reactionsCount,
        required this.reportsCount,
    });

    factory Relationships.fromJson(Map<String, dynamic> json) => Relationships(
        status: Status.fromJson(json["status"]),
        post: json["post"] == null ? null : Post.fromJson(json["post"]),
        file: List<FileElement>.from(json["file"].map((x) => FileElement.fromJson(x))),
        reactions: List<Reaction>.from(json["reactions"].map((x) => Reaction.fromJson(x))),
        reactionsCount: json["reactions_count"],
        reportsCount: json["reports_count"],
    );

    Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "post": post?.toJson(),
        "file": List<dynamic>.from(file.map((x) => x.toJson())),
        "reactions": List<dynamic>.from(reactions.map((x) => x)),
        "reactions_count": reactionsCount,
        "reports_count": reportsCount,
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
    String body;
    dynamic postId;
    int userId;
    int statusId;
    int typePostId;
    DateTime createdAt;
    DateTime updatedAt;

    PostAttributes({
        required this.body,
        required this.postId,
        required this.userId,
        required this.statusId,
        required this.typePostId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory PostAttributes.fromJson(Map<String, dynamic> json) => PostAttributes(
        body: json["body"],
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
    dynamic post;
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
        post: json["post"],
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


