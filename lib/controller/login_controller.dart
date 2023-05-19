import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/widgets.dart';
import 'package:im/model/user_login_model.dart';
import 'package:im/router/app_router.dart';
import 'package:im/util/shared_preferences_util.dart';

import 'package:im/util/text_util.dart';
import 'package:im/api/api.dart';

class LoginController extends GetxController{
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

    _usernameTextEditingController.addListener(()=>  _username = _usernameTextEditingController.text);
    _passwordTextEditingController.addListener(()=>  _password = _passwordTextEditingController.text);
  }

  login() async {
    /// 处理登录的业务逻辑
    if(TextUtils.isEmpty(_username) || TextUtils.isEmpty(_password)){
      EasyLoading.showToast("用户名或密码不能为空");
      return;
    }
    UserLoginModel loginModel = await Api.login(username, password);

    // 保存用户信息
    SpUtil.setValue("token", loginModel.token);
    SpUtil.setValue("userInfo", loginModel.user);

    // 跳转到首页
    Get.offNamed(AppRouter.menuContainer);
  }
}