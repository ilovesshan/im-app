import 'dart:convert';

FriendModel userModelFromJson(String str) => FriendModel.fromJson(json.decode(str));

String userModelToJson(FriendModel data) => json.encode(data.toJson());

class FriendModel {
  int id;
  String username;
  String image;

  FriendModel({
    required this.id,
    required this.username,
    required this.image,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) => FriendModel(
    id: json["id"],
    username: json["username"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "image": image,
  };
}
