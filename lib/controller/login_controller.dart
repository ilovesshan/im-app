import 'package:flutter/material.dart';
import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/api/api.dart';
import 'package:im/controller/socket_controller.dart';
import 'package:im/model/user_login_model.dart';

class LoginController extends GetxController {
  /// 用户名 EditingController
  late final TextEditingController _usernameTextEditingController = TextEditingController(text: "ilovesshan");

  /// 密码 EditingController
  late final TextEditingController _passwordTextEditingController = TextEditingController(text: "123456");

  TextEditingController get usernameTextEditingController => _usernameTextEditingController;
  TextEditingController get passwordTextEditingController => _passwordTextEditingController;


  /// 处理登录逻辑
  Future<void> login() async {
    String username = usernameTextEditingController.text;
    String password = passwordTextEditingController.text;

    /// 处理登录的业务逻辑
    if (TextUtil.isEmpty(username) || TextUtil.isEmpty(password)) {
      ToastUtil.show("用户名或密码不能为空");
      return;
    }
    UserLoginModel loginModel = await Api.login(username, password);

    /// 保存用户信息
    SpUtil.setValue("token", loginModel.token);
    SpUtil.setValue("userId", "${loginModel.user.id}");
    SpUtil.setValue("username", loginModel.user.username);
    SpUtil.setValue("image", loginModel.user.image);

    // TODO: 应该由服务端主动推送（后期优化）
    /// 给服务器发送消息 当前用户上线了
    final SocketController _socketController = Get.find<SocketController>();
    _socketController.userLogin(loginModel.user.id);
  }
}
