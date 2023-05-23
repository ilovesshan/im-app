import 'package:flutter/material.dart';

import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/controller/friend_list_controller.dart';
import 'package:im/model/friend_model.dart';
import 'package:im/router/app_router.dart';
import 'package:im/widgets/user_avatar_widget.dart';


class FriendPage extends StatelessWidget {
  FriendPage({Key? key}) : super(key: key);

  FriendListController _friendListController = Get.put(FriendListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      appBar: AppBar(
        elevation: 2,
        title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("朋友",style: TextStyle(color: Get.theme.primaryColor)),
              SizedBox(width: 10),
            ]
        ),
        backgroundColor: Colors.white,
        actions: [buildPopupMenuButton()],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding:EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                buildFriendFunctionItem(Icons.person_add_outlined, "新的好友",()=>Get.toNamed(AppRouter.friendApply)!.then((value) => _friendListController.queryFriendList())),
                buildFriendFunctionItem(Icons.group_add_outlined, "群通知",()=> EasyLoading.showToast("群通知"))
              ],
            ),
          ),

          SizedBox(height: 5),
          Padding(padding: EdgeInsets.only(left: 10), child: Text("联系人列表")),
          SizedBox(height: 5),

          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              padding:EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GetBuilder<FriendListController>(
                init: _friendListController,
                builder: (_friendController){
                  return  ListView.builder(itemBuilder: (context, index){
                    FriendModel friendModel =  _friendController.friendsList[index];
                    return GestureDetector(child: buildFriendListItem(friendModel), onTap: () async {
                      final String? userId = await SpUtil.getValue("userId");
                      Get.toNamed("${AppRouter.chat}?fid=${friendModel.id}&uid=$userId&name=${friendModel.username}");
                    });
                  }, itemCount: _friendController.friendsList.length);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildFriendListItem(FriendModel friendModel) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xffefefef)))),
      child: Row(
        children: [
          UserAvatarWidget(avatarName: friendModel.username, avatarPath: friendModel.image, radius: 5),
          SizedBox(width: 5),
          Text(friendModel.username, style: TextStyle(fontSize: 16))
        ],
      ),
    );
  }

  Widget buildFriendFunctionItem( IconData iconData, String text,Function onClick) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xffefefef)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width:40, height: 40, decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Colors.green),
              child: Icon(iconData, color: Colors.white),
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text, textAlign: TextAlign.left, style: TextStyle(fontSize: 16))),
            Icon(Icons.keyboard_arrow_right, color: Colors.grey)
          ],
        ),
      ),
      onTap: ()=> onClick(),
    );
  }

  PopupMenuButton<String> buildPopupMenuButton() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.add_circle_outline_outlined, color: Colors.black),
      onSelected: (value) {
        switch(value){
          case "addFriend":
            Get.toNamed(AppRouter.addFriend);
            break;
          case "scan":
            EasyLoading.showToast("扫一扫");
            break;
          case "myCard":
            EasyLoading.showToast("我的名片");
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
            value: 'myCard',
            child: Row(children: [Icon(Icons.person_outline_outlined, color: Colors.black), SizedBox(width: 10), Text('我的名片')]),
          ),
          PopupMenuItem<String>(
            value: 'scan',
            child: Row(children: [Icon(Icons.add_a_photo_outlined, color: Colors.black), SizedBox(width: 10), Text('扫一扫')]),
          ),
        ];
      },
    );
  }
}
