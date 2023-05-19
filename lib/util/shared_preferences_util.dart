import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SpUtil {
  /// 根据Key取值
  static Object getValue(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Object? value = sp.get(key);
    if (value == null) return "";
    return json.decode(value as String);
  }

  /// 根据key设置值
  static setValue(String key, String value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, json.encode(value));
  }

  /// 根据key删除值
  static removeValue(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(key);
  }
}
