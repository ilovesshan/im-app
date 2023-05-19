import 'package:im/model/friend_model.dart';
import 'package:im/model/user_login_model.dart';
import 'package:im/util/http_helper.dart';

class Api {
  static const String loginPath = "/login";
  static const String friend = "/friend";


  /// 登录接口
  static Future<UserLoginModel> login(String username, String password) async {
    final Map<String, dynamic> response = await HttpHelper.instance.post(loginPath, data: {"username": username, "password": password});
    late UserLoginModel userLoginModel;
    if(response !=null && response["data"] !=null){
      userLoginModel = UserLoginModel.fromJson(response["data"]);
    }
    return userLoginModel;
  }

  /// 获取好友列表接口
  static Future<List<FriendModel>> queryFriendList() async {
    final Map<String, dynamic> response = await HttpHelper.instance.get(friend);
    late List<FriendModel> friendModelList = [];
    if(response !=null && response["data"] !=null){
      for(var friend in response["data"]){
        friendModelList.add(FriendModel.fromJson(friend));
      }
    }
    return friendModelList;
  }
}
