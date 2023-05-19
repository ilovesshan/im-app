import 'package:im/model/user_model.dart';
import 'dart:convert';

UserLoginModel userLoginModelFromJson(String str) => UserLoginModel.fromJson(json.decode(str));

String userLoginModelToJson(UserLoginModel data) => json.encode(data.toJson());

class UserLoginModel {
  UserModel user;
  String token;

  UserLoginModel({
    required this.user,
    required this.token,
  });

  factory UserLoginModel.fromJson(Map<String, dynamic> json) => UserLoginModel(
    user: UserModel.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "token": token,
  };
}
