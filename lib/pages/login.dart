import 'package:flutter/material.dart';

import 'package:bruno/bruno.dart';
import 'package:common_utils_v2/common_utils_v2.dart';


import 'package:im/controller/login_controller.dart';


class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           Text("HI, Welcome To IM World~", style: TextStyle(fontSize: 24, color: Get.theme.primaryColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 160),
            BrnTextInputFormItem(title: "用户名", controller: loginController.usernameTextEditingController),
            const SizedBox(height: 20),
            BrnTextInputFormItem(title: "密码", controller:  loginController.passwordTextEditingController, inputType: BrnInputType .pwd),
            const SizedBox(height: 40),
            BrnBigMainButton(
              title: '登录',
              onTap: () {
                loginController.login();
                // Get.offNamed(AppRouter.menuContainer);
              },
            )
          ],
        ),
      ),
    );
  }
}
