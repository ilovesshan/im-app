import 'package:im/model/user_login_model.dart';
import 'package:im/util/http_helper.dart';

class Api {
  static const String loginPath = "/login";


  /// 登录接口
  static Future<UserLoginModel> login(String username, String password) async {
    final Map<String, dynamic> response = await HttpHelper.instance.post(loginPath, data: {"username": username, "password": password});
    late UserLoginModel userLoginModel;
    if(response !=null && response["data"] !=null){
      userLoginModel = UserLoginModel.fromJson(response["data"]);
    }
    return userLoginModel;
  }
}
