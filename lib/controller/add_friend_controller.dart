import 'package:flutter/material.dart';

import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/api/api.dart';
import 'package:im/model/user_model.dart';

class AddFriendListController extends GetxController {
  final List<UserModel> _searchResultUserList = <UserModel>[].obs;
  final TextEditingController _kwTextEditingController = TextEditingController();

  List<UserModel> get searchResultUserList => _searchResultUserList;
  TextEditingController get kwTextEditingController => _kwTextEditingController;

  /// 搜索用户列表
  searchUserList() async {
    final List<UserModel> friendModelList = await Api.searchUserList(_kwTextEditingController.text);
    _searchResultUserList.clear();
    _searchResultUserList.addAll(friendModelList);
  }

  /// 添加用户
  Future<void> addFriend(int id) async {
    await Api.addFriend(id);
  }
}
