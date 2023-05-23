import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/api/api.dart';
import 'package:im/model/recently_message_model.dart';
import 'package:im/model/user_model.dart';

class MessageController extends GetxController {
  final UserModel  _userModel = UserModel(id: 0, username: "IM", image: "");
  final List<RecentlyMessageModel> _recentlyMessageModelList = [];

  UserModel get userModel => _userModel;
  List<RecentlyMessageModel> get recentlyMessageModelList => _recentlyMessageModelList;


  @override
  void onInit() async {
    super.onInit();
    /// 获取当前用户数据
    // queryUserInfo();

    /// 查询全部好友最近一条聊天记录
    // queryRecentlyMessageList();
  }

  /// 获取当前用户数据
  queryUserInfo() async {
    final String? userId = await SpUtil.getValue("userId");
    final String? username = await SpUtil.getValue("username");
    final String? image = await SpUtil.getValue("image");

    _userModel.id = int.parse(userId!);
    _userModel.username = username!;
    _userModel.image = image!;

    /// 更新UI
    update();
  }


  /// 查询全部好友最近一条聊天记录
  void queryRecentlyMessageList() async {
    final List<RecentlyMessageModel> recentlyMessageModelList = await Api.queryRecentlyMessageList();
    _recentlyMessageModelList.clear();
    _recentlyMessageModelList.addAll(recentlyMessageModelList);
    /// 更新UI
    update();
  }
}
