import 'package:im/model/user_login_model.dart';
import 'package:im/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SpUtil {
  /// 根据Key取值
  static Future<Object> getValue(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Object? value = sp.get(key);
    if (value == null) return "";
    return json.decode(value as String);
  }

  /// 根据key设置值
  static setValue(String key, Object value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, json.encode(value));
  }

  /// 根据key删除值
  static removeValue(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(key);
  }

  static Future<UserModel> getUserModel() async {
    Object userInfoJson = await getValue("userInfo");
    UserModel userModel = UserModel.fromJson(userInfoJson as Map<String,dynamic>);
    return userModel;
  }
}
