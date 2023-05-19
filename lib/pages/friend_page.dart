import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:im/controller/friend_controller.dart';
import 'package:im/controller/message_controller.dart';
import 'package:im/model/friend_model.dart';
import 'package:im/router/app_router.dart';
import 'package:im/util/shared_preferences_util.dart';
import 'package:im/widgets/message_item.dart';
import 'package:im/widgets/no_scrol_behavior_widget.dart';
import 'package:im/widgets/user_avatar_widget.dart';


class FriendPage extends StatelessWidget {
  FriendPage({Key? key}) : super(key: key);

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
        actions: [Icon(Icons.add_circle_outline_outlined, color: Colors.black), SizedBox(width: 16)],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding:EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                buildFriendFunctionItem(Icons.person_add_outlined, "新的好友" ),
                buildFriendFunctionItem(Icons.group_add_outlined, "群通知")
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
              child: ScrollConfiguration(
                behavior: NoScrollBehaviorWidget(),
                child: GetBuilder<FriendController>(
                  init: FriendController(),
                  builder: (_friendController){
                    return  ListView.builder(itemBuilder: (context, index){
                      FriendModel friendModel =  _friendController.friendsList[index];
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
                    }, itemCount: _friendController.friendsList.length);
                  },
                )
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildFriendFunctionItem(IconData iconData, String text) {
    return Container(
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
    );
  }
}
