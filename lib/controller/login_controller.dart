import 'package:flutter/material.dart';

import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/api/api.dart';
import 'package:im/controller/socket_controller.dart';
import 'package:im/model/user_login_model.dart';
import 'package:im/router/app_router.dart';


class LoginController extends GetxController {
  final SocketController _socketController = Get.put<SocketController>(SocketController());

  /// 用户名
  var _username = "ilovesshan";
  /// 密码
  var _password = "123456";

  late TextEditingController _usernameTextEditingController;
  late TextEditingController _passwordTextEditingController;

  get username => _username;
  get password => _password;

  TextEditingController get usernameTextEditingController => _usernameTextEditingController;
  TextEditingController get passwordTextEditingController => _passwordTextEditingController;

  @override
  void onInit() {
    super.onInit();
    _usernameTextEditingController = TextEditingController(text: _username);
    _passwordTextEditingController = TextEditingController(text: _password);

    _usernameTextEditingController.addListener(() => _username = _usernameTextEditingController.text);
    _passwordTextEditingController.addListener(() => _password = _passwordTextEditingController.text);
  }

  login() async {
    /// 处理登录的业务逻辑
    if (TextUtil.isEmpty(_username) || TextUtil.isEmpty(_password)) {
      ToastUtil.show("用户名或密码不能为空");
      return;
    }
    UserLoginModel loginModel = await Api.login(username, password);

    // 保存用户信息
    SpUtil.setValue("token", loginModel.token);
    SpUtil.setValue("userId", "${loginModel.user.id}");
    SpUtil.setValue("username", loginModel.user.username);
    SpUtil.setValue("image", loginModel.user.image);

    // 跳转到首页
    Get.offNamed(AppRouter.menuContainer);

    // 发送消息给服务器 当前用户上线了
    _socketController.userLogin(loginModel.user.id);
  }
}
