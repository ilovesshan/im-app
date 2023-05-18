import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:im/router/app_router.dart';
import 'package:im/widgets/message_item.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("消息"),
        centerTitle: true,
        elevation: 0,
        actions: [buildPopupMenuButton()],
      ),
      body: ListView.builder(itemBuilder: (context, index){
        return GestureDetector(
          child: MessageItem(),
          onTap: ()=> Get.toNamed("${AppRouter.chat}?messageId=$index"),
        );
      }, itemCount: 10),
    );
  }

  PopupMenuButton<String> buildPopupMenuButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch(value){
          case "add":
            Get.toNamed(AppRouter.addFriend);
            break;
          case "create":
            EasyLoading.showToast("创建群聊");
            break;
          case "scan":
            EasyLoading.showToast("扫一扫");
            break;
        }
      },
      itemBuilder: (context) {
        return const <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'add',
            child: Text('添加朋友'),
          ),
          PopupMenuItem<String>(
            value: 'create',
            child: Text('创建群聊'),
          ),
          PopupMenuItem<String>(
            value: 'scan',
            child: Text('扫一扫'),
          ),
        ];
      },
    );
  }
}
