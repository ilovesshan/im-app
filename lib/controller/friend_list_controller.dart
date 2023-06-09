import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/api/api.dart';
import 'package:im/model/friend_model.dart';

class FriendListController extends GetxController {

  final List<FriendModel> _friendsList = <FriendModel>[].obs;
  List<FriendModel> get friendsList => _friendsList;

  @override
  void onInit() async {
    super.onInit();
    /// 请求好友列表
    Future.delayed(const Duration(seconds: 1),()=> queryFriendList());
  }

  Future<void> queryFriendList() async {
     final List<FriendModel> friendModelList = await Api.queryFriendList();
     _friendsList.clear();
    _friendsList.addAll(friendModelList);
  }
}
