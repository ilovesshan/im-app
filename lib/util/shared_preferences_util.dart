import 'package:im/model/user_login_model.dart';
import 'package:im/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesUtil {
  static late SharedPreferences sharedPreferences;

  ///初始化工具
  static Future<bool> initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return true;
  }
}

class SpUtil {
  /// 根据Key取值
  static Future<String> getValue(String key) async {
    try {
      return await SharedPreferencesUtil.sharedPreferences.getString(key)!;
    } catch (e) {
      print(e);
      return "";
    }
  }

  /// 根据key设置值
  static setValue(String key, String value) async {
    SharedPreferencesUtil.sharedPreferences.setString(key, value);
  }

  /// 根据key删除值
  static removeValue(String key) async {
    SharedPreferencesUtil.sharedPreferences.remove(key);
  }
}
