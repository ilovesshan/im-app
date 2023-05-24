import 'package:flutter/material.dart';

import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/api/api.dart';
import 'package:im/model/user_model.dart';

class AddFriendListController extends GetxController {
  final List<UserModel> _searchResultUserList = [];
  late TextEditingController _kwTextEditingController = TextEditingController();

  List<UserModel> get searchResultUserList => _searchResultUserList;

  TextEditingController get kwTextEditingController => _kwTextEditingController;

  /// 搜索用户列表
  searchUserList() async {
    final List<UserModel> friendModelList = await Api.searchUserList(_kwTextEditingController.text);
    _searchResultUserList.clear();
    _searchResultUserList.addAll(friendModelList);
    update();
  }

  /// 添加用户
  void addFriend(int id) async {
    await Api.addFriend(id);
    ToastUtil.show("请求已发送，等待对方同意");
    Get.back();
  }
}
