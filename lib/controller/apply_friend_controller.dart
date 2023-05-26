import 'package:flutter/material.dart';

import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/api/api.dart';
import 'package:im/model/user_model.dart';

class ApplyFriendListController extends GetxController {
  final List<UserModel> _applyUserList = <UserModel>[].obs;
  late final TextEditingController _kwTextEditingController = TextEditingController();

  List<UserModel> get applyUserList => _applyUserList;
  TextEditingController get kwTextEditingController => _kwTextEditingController;

  @override
  void onInit() {
    super.onInit();
    queryFriendApplyList();
  }

  /// 查询好友申请列表
  queryFriendApplyList() async {
    final List<UserModel> friendModelList = await Api.queryFriendApplyList();
    _applyUserList.clear();
    _applyUserList.addAll(friendModelList);
  }

  /// 同意好友申请
  Future<void> agreeFriendApply(int id) async {
    await Api.agreeOrRefuseFriendApply("1", id);
    queryFriendApplyList();
  }

  /// 拒绝好友申请
  Future<void> refuseFriendApply(int id) async {
    await Api.agreeOrRefuseFriendApply("2", id);
    queryFriendApplyList();
  }
}
