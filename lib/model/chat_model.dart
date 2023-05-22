import 'package:im/model/user_model.dart';
import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  List<Message> message;
  UserModel muser;
  UserModel yuser;

  ChatModel({
    required this.message,
    required this.muser,
    required this.yuser,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    message: json["message"] == null ? [] : List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
    muser: UserModel.fromJson(json["muser"]),
    yuser: UserModel.fromJson(json["yuser"]),
  );

  Map<String, dynamic> toJson() => {
    "message": List<dynamic>.from(message.map((x) => x.toJson())),
    "muser": muser.toJson(),
    "yuser": yuser.toJson(),
  };
}

class Message {
  int id;
  int from;
  int to;
  int type;
  String content;
  DateTime time;

  Message({
    required this.id,
    required this.from,
    required this.to,
    required this.type,
    required this.content,
    required this.time,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    from: json["from"],
    to: json["to"],
    type: json["type"],
    content: json["content"],
    time: DateTime.parse(json["time"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from": from,
    "to": to,
    "type": type,
    "content": content,
    "time": time.toIso8601String(),
  };
}
