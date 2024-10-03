// To parse this JSON data, do
//
//     final groupsModel = groupsModelFromJson(jsonString);

import 'dart:convert';

GroupsModel groupsModelFromJson(String str) =>
    GroupsModel.fromJson(json.decode(str));

String groupsModelToJson(GroupsModel data) => json.encode(data.toJson());

class GroupsModel {
  final List<Datum> data;

  GroupsModel({
    required this.data,
  });

  factory GroupsModel.fromJson(Map<String, dynamic> json) => GroupsModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  final int id;
  final Attributes attributes;

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
  final String name;

  Attributes({
    required this.name,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
