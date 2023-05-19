import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
    EasyLoading.showToast("添加成功");
    Get.back();
  }
}
