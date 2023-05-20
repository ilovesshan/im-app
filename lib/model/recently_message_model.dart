import 'package:meta/meta.dart';
import 'dart:convert';

RecentlyMessageModel recentlyMessageModelFromJson(String str) => RecentlyMessageModel.fromJson(json.decode(str));

String recentlyMessageModelToJson(RecentlyMessageModel data) => json.encode(data.toJson());

class RecentlyMessageModel {
  int id;
  int from;
  int to;
  int type;
  String content;
  int userId;
  String username;
  String image;
  String time;

  RecentlyMessageModel({
    required this.id,
    required this.from,
    required this.to,
    required this.type,
    required this.content,
    required this.userId,
    required this.username,
    required this.image,
    required this.time,
  });

  factory RecentlyMessageModel.fromJson(Map<String, dynamic> json) => RecentlyMessageModel(
    id: json["id"],
    from: json["from"],
    to: json["to"],
    type: json["type"],
    content: json["content"],
    userId: json["userId"],
    username: json["username"],
    image: json["image"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from": from,
    "to": to,
    "type": type,
    "content": content,
    "userId": userId,
    "username": username,
    "image": image,
    "time": time
  };
}
