import 'package:flutter/material.dart';

import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/controller/message_controller.dart';
import 'package:im/model/recently_message_model.dart';
import 'package:im/model/user_model.dart';
import 'package:im/router/app_router.dart';
import 'package:im/widgets/recently_message_item.dart';
import 'package:im/widgets/user_avatar_widget.dart';

class MessagePage extends StatelessWidget {
  MessagePage({Key? key}) : super(key: key);
  final MessageController _messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Obx(() => Text(_messageController.userModel.username, style: TextStyle(color: Colors.black))),
            SizedBox(width: 10),
            Row(
              children: [
                ClipRRect(child: Container(width: 8, height: 8, color: Colors.green), borderRadius: BorderRadius.circular(10)),
                SizedBox(width: 4),
                Text("在线", style: TextStyle(color: Colors.black, fontSize: 12)),
              ],
            )
          ],
        ),
        leading: Obx(() => UserAvatarWidget(radius: 20, avatarName: _messageController.userModel.username, avatarPath: _messageController.userModel.image)),
        backgroundColor: Colors.white,
        actions: [buildPopupMenuButton()],
      ),
      body: Obx(
        () => EasyRefresh(
          header: CustomRefreshHeader(),
          footer: CustomRefreshFooter(),
          child: ListView.builder(
            itemBuilder: (context, index) {
              final RecentlyMessageModel recentlyMessageModel = _messageController.recentlyMessageModelList[index];
              final UserModel userModel = _messageController.userModel;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: RecentlyMessageItem(recentlyMessageModel: _messageController.recentlyMessageModelList[index]),
                onTap: () {
                  int fid = recentlyMessageModel.to;
                  if (userModel.id == recentlyMessageModel.to) {
                    fid = recentlyMessageModel.from;
                  }
                  final targetPath = "${AppRouter.chat}?fid=$fid&uid=${userModel.id}&name=${recentlyMessageModel.username}";
                  Get.toNamed(targetPath)!.then((value) => {_messageController.queryRecentlyMessageList()});
                },
              );
            },
            itemCount: _messageController.recentlyMessageModelList.length,
          ),
          onRefresh: () async {
            await _messageController.queryRecentlyMessageList();
          },
        ),
      ),
    );
  }

  PopupMenuButton<String> buildPopupMenuButton() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_outlined, color: Colors.black),
      onSelected: (value) {
        switch (value) {
          case "addFriend":
            Get.toNamed(AppRouter.addFriend);
            break;
          case "createGroup":
            ToastUtil.show("创建群聊");
            break;
          case "addGroup":
            ToastUtil.show("添加群聊");
            break;
          case "myCard":
            ToastUtil.show("我的名片");
            break;
          case "scan":
            ToastUtil.show("扫一扫");
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
            child: Row(children: [Icon(Icons.group_add, color: Colors.black), SizedBox(width: 10), Text('创建群聊')]),
          ),
          PopupMenuItem<String>(
            value: 'addGroup',
            child: Row(children: [Icon(Icons.people_alt_outlined, color: Colors.black), SizedBox(width: 10), Text('添加群聊')]),
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
