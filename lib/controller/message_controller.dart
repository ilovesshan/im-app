import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/api/api.dart';
import 'package:im/model/recently_message_model.dart';
import 'package:im/model/user_model.dart';

class MessageController extends GetxController {
  final _userModel = UserModel(id: 0, username: "IM", image: "").obs;
  final _recentlyMessageModelList = <RecentlyMessageModel>[].obs;

  UserModel get userModel => _userModel.value;
  List<RecentlyMessageModel> get recentlyMessageModelList => _recentlyMessageModelList;

  @override
  void onInit() {
    super.onInit();
    queryUserInfo();
    queryRecentlyMessageList();
  }

  /// 获取当前用户数据
  queryUserInfo() async {
    /// 从Sp中获取
    _userModel.update((val) {
      val!.id = int.parse(SpUtil.getValue("userId")!);
      val.username = SpUtil.getValue("username")!;
      val.image = SpUtil.getValue("image")!;
    });
  }

  /// 查询全部好友最近一条聊天记录
  Future<void> queryRecentlyMessageList() async {
    final List<RecentlyMessageModel> recentlyMessageModelList = await Api.queryRecentlyMessageList();
    _recentlyMessageModelList.clear();
    _recentlyMessageModelList.addAll(recentlyMessageModelList);
  }
}
