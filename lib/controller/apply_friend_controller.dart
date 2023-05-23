import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/api/api.dart';
import 'package:im/model/user_model.dart';

class ApplyFriendListController extends GetxController {
  final List<UserModel> _applyUserList = [];
  late TextEditingController _kwTextEditingController = TextEditingController();

  List<UserModel> get applyUserList => _applyUserList;

  TextEditingController get kwTextEditingController => _kwTextEditingController;


  @override
  void onInit() {
    queryFriendApplyList();
  }

  /// 查询好友申请列表
  queryFriendApplyList() async {
    final List<UserModel> friendModelList = await Api.queryFriendApplyList();
    _applyUserList.clear();
    _applyUserList.addAll(friendModelList);
    update();
  }

  /// 同意好友申请
  void agreeFriendApply(int id) async {
    await Api.agreeOrRefuseFriendApply("1", id);
    EasyLoading.showToast("已同意");
    queryFriendApplyList();
  }

  /// 拒绝好友申请
  void refuseFriendApply(int id) async {
    await Api.agreeOrRefuseFriendApply("2", id);
    EasyLoading.showToast("已拒绝");
    queryFriendApplyList();
  }
}
