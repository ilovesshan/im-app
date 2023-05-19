import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:im/controller/message_controller.dart';
import 'package:im/router/app_router.dart';
import 'package:im/util/shared_preferences_util.dart';
import 'package:im/widgets/message_item.dart';
import 'package:im/widgets/user_avatar_widget.dart';

class MessagePage extends StatelessWidget {
  MessagePage({Key? key}) : super(key: key);
  MessageController messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        title: Obx(()=>Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(messageController.userModel.value.username,style: TextStyle(color: Colors.black)),
          SizedBox(width: 10),
            Row(
              children: [
                ClipRRect(child: Container(width: 8, height: 8, color: Colors.green), borderRadius: BorderRadius.circular(10)),
                SizedBox(width: 4),
                Text("在线",style: TextStyle(color: Colors.black, fontSize: 12)),
              ],
            )
          ]
        )),
        leading: Obx(()=>UserAvatarWidget(avatarName: messageController.userModel.value.username, avatarPath: messageController.userModel.value.image)),
        backgroundColor: Colors.white,
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
      icon: Icon(Icons.more_vert_outlined, color: Colors.black),
      onSelected: (value) {
        switch(value){
          case "addFriend":
            Get.toNamed(AppRouter.addFriend);
            break;
          case "createGroup":
            EasyLoading.showToast("创建群聊");
            break;
          case "addGroup":
            EasyLoading.showToast("添加群聊");
           break;
          case "myCard":
            EasyLoading.showToast("我的名片");
            break;
          case "scan":
            EasyLoading.showToast("扫一扫");
            break;
          case "logout":
            SpUtil.removeValue("token");
            SpUtil.removeValue("userInfo");
            Get.offAndToNamed(AppRouter.login);
            break;
        }
      },
      itemBuilder: (context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'addFriend',
            child: Row(children: [Icon(Icons.add_outlined, color: Colors.black), SizedBox(width: 10), Text('添加朋友')]),
          ),
          PopupMenuItem<String>(
            value: 'createGroup',
            child: Row(children: [Icon(Icons.people_alt_outlined, color: Colors.black), SizedBox(width: 10), Text('创建群聊')]),
          ),
          PopupMenuItem<String>(
            value: 'addGroup',
            child: Row(children: [Icon(Icons.group_add, color: Colors.black), SizedBox(width: 10), Text('添加群聊')]),
          ),
          PopupMenuItem<String>(
            value: 'myCard',
            child: Row(children: [Icon(Icons.person_outline_outlined, color: Colors.black), SizedBox(width: 10), Text('我的名片')]),
          ),
          PopupMenuItem<String>(
            value: 'scan',
            child: Row(children: [Icon(Icons.add_a_photo_outlined, color: Colors.black), SizedBox(width: 10), Text('扫一扫')]),
          ),
          PopupMenuItem<String>(
            value: 'logout',
            child: Row(children: [Icon(Icons.logout_outlined, color: Colors.black), SizedBox(width: 10), Text('退出登录')]),
          ),
        ];
      },
    );
  }
}
