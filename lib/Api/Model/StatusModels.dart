import 'dart:convert';

StatusesModel statusesModelFromJson(String str) => StatusesModel.fromJson(json.decode(str));

String statusesModelToJson(StatusesModel data) => json.encode(data.toJson());

class StatusesModel {
    List<Datum> data;

    StatusesModel({
        required this.data,
    });

    factory StatusesModel.fromJson(Map<String, dynamic> json) => StatusesModel(
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
    String name;
    String? description;
    DateTime createdAt;
    DateTime updatedAt;

    Attributes({
        required this.name,
        this.description,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
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
