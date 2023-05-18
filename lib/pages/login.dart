import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:bruno/bruno.dart';
import 'package:im/router/app_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
            BrnTextInputFormItem(
                title: "用户名",
                controller: TextEditingController()..text = "ilovesshan",
            ),
            const SizedBox(height: 20),
            BrnTextInputFormItem(
              controller: TextEditingController()..text = "",
              title: "密码",
              inputType: BrnInputType .pwd,
            ),
            const SizedBox(height: 40),

            BrnBigMainButton(
              title: '登录',
              onTap: () {
                Get.offNamed(AppRouter.menuContainer);
              },
            )
          ],
        ),
      ),
    );
  }
}
