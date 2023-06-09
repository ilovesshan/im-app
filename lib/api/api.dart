import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/model/chat_model.dart';
import 'package:im/model/friend_model.dart';
import 'package:im/model/recently_message_model.dart';
import 'package:im/model/user_login_model.dart';
import 'package:im/model/user_model.dart';


class Api {
  static const String loginPath = "/login";
  static const String friend = "/friend";
  static const String friendApply = "/friend/apply";
  static const String chat = "/chat";
  static const String message = "/message";
  static const String recentlyMessage = "/message/recently";

  /// 登录接口
  static Future<UserLoginModel> login(String username, String password) async {
    final Map<String, dynamic> response = await HttpHelperUtil.instance.post(loginPath, data: {"username": username, "password": password});
    late UserLoginModel userLoginModel;
    if (response != null && response["data"] != null) {
      userLoginModel = UserLoginModel.fromJson(response["data"]);
    }
    return userLoginModel;
  }

  /// 获取好友列表接口
  static Future<List<FriendModel>> queryFriendList() async {
    final Map<String, dynamic> response = await HttpHelperUtil.instance.get(friend);
    late List<FriendModel> friendModelList = [];
    if (response != null && response["data"] != null) {
      for (var friend in response["data"]) {
        friendModelList.add(FriendModel.fromJson(friend));
      }
    }
    return friendModelList;
  }

  /// 搜索用户接口
  static Future<List<UserModel>> searchUserList(String kw) async {
    final Map<String, dynamic> response = await HttpHelperUtil.instance.get("$friend/$kw");
    late List<UserModel> userModelList = [];
    if (response != null && response["data"] != null) {
      for (var friend in response["data"]) {
        userModelList.add(UserModel.fromJson(friend));
      }
    }
    return userModelList;
  }

  /// 添加用户接口
  static Future<bool> addFriend(int id) async {
    await HttpHelperUtil.instance.post("$friend/$id");
    return true;
  }

  /// 查询好友申请列表接口
  static Future<List<UserModel>> queryFriendApplyList() async {
    final Map<String, dynamic> response = await HttpHelperUtil.instance.get(friendApply);
    late List<UserModel> userModelList = [];
    if (response != null && response["data"] != null) {
      for (var friend in response["data"]) {
        userModelList.add(UserModel.fromJson(friend));
      }
    }
    return userModelList;
  }

  /// 同意/拒绝好友申请接口
  static agreeOrRefuseFriendApply(String type, int id) async {
    await HttpHelperUtil.instance.put("$friendApply/$type/$id");
    return true;
  }

  /// 查询聊天记录列表接口
  static Future<ChatModel> queryChatList(int fid) async {
    final Map<String, dynamic> response = await HttpHelperUtil.instance.get("$message/$fid");
    late ChatModel chatModel;
    if (response != null && response["data"] != null) {
      chatModel = ChatModel.fromJson(response["data"]);
    }
    return chatModel;
  }

  /// 发送聊天记录接口
  static Future<bool> sendMessage(Map<String, Object> requestBody) async {
    await HttpHelperUtil.instance.post(message, data: requestBody);
    return true;
  }

  /// 查询全部好友最近一条聊天记录接口
  static Future<List<RecentlyMessageModel>> queryRecentlyMessageList() async {
    final Map<String, dynamic> response = await HttpHelperUtil.instance.get(recentlyMessage);
    late List<RecentlyMessageModel> recentlyMessageModelList = [];
    if (response != null && response["data"] != null) {
      for (var message in response["data"]) {
        recentlyMessageModelList.add(RecentlyMessageModel.fromJson(message));
      }
    }
    return recentlyMessageModelList;
  }
}
