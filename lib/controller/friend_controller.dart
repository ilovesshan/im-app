import 'package:get/get.dart';
import 'package:im/api/api.dart';
import 'package:im/model/friend_model.dart';

class FriendController extends GetxController {
  final List<FriendModel> _friendsList = [];

  List<FriendModel> get friendsList => _friendsList;

  @override
  void onInit() async {
    super.onInit();
    // 请求好友列表
    final List<FriendModel> friendModelList = await Api.queryFriendList();
    _friendsList.addAll(friendModelList);
    update();
  }
}
