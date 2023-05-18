// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  MUser mUser;
  YUser yUser;
  List<Message> message;

  ChatModel({
    required this.mUser,
    required this.yUser,
    required this.message,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    mUser: MUser.fromJson(json["mUser"]),
    yUser: YUser.fromJson(json["yUser"]),
    message: List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "mUser": mUser.toJson(),
    "yUser": yUser.toJson(),
    "message": List<dynamic>.from(message.map((x) => x.toJson())),
  };
}

class MUser {
  String mNickname;
  String mAvatarUrl;

  MUser({
    required this.mNickname,
    required this.mAvatarUrl,
  });

  factory MUser.fromJson(Map<String, dynamic> json) => MUser(
    mNickname: json["mNickname"],
    mAvatarUrl: json["mAvatarUrl"],
  );

  Map<String, dynamic> toJson() => {
    "mNickname": mNickname,
    "mAvatarUrl": mAvatarUrl,
  };
}

class Message {
  String text;
  bool isCurrentUser;

  Message({
    required this.text,
    required this.isCurrentUser,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    text: json["text"],
    isCurrentUser: json["isCurrentUser"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "isCurrentUser": isCurrentUser,
  };
}

class YUser {
  String yNickname;
  String yAvatarUrl;

  YUser({
    required this.yNickname,
    required this.yAvatarUrl,
  });

  factory YUser.fromJson(Map<String, dynamic> json) => YUser(
    yNickname: json["yNickname"],
    yAvatarUrl: json["yAvatarUrl"],
  );

  Map<String, dynamic> toJson() => {
    "yNickname": yNickname,
    "yAvatarUrl": yAvatarUrl,
  };
}
