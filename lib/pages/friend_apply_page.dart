import 'package:flutter/material.dart';

import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/controller/apply_friend_controller.dart';
import 'package:im/model/user_model.dart';
import 'package:im/widgets/user_avatar_widget.dart';

class FriendApplyPage extends StatelessWidget {
  FriendApplyPage({Key? key}) : super(key: key);

  final ApplyFriendListController _applyFriendListController = Get.put(ApplyFriendListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        title: Text("新的好友", style: TextStyle(color: Colors.black)),
        leading: GestureDetector(child: Icon(Icons.arrow_back, color: Colors.black), onTap: () => Get.back()),
      ),
      body: Obx(
        () => ListView.builder(
          itemBuilder: (context, index) {
            final UserModel userModel = _applyFriendListController.applyUserList[index];
            return Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(left: 5, right: 10),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xffefefef)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserAvatarWidget(avatarName: userModel.username, avatarPath: userModel.image, radius: 20),
                  Padding(padding: EdgeInsets.only(left: 10), child: Text(userModel.username, style: TextStyle(fontSize: 16), textAlign: TextAlign.left)),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          child: Text("同意", style: TextStyle(fontSize: 14)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.green),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0)),
                            minimumSize: MaterialStateProperty.all(Size(0, 0)),
                            maximumSize: MaterialStateProperty.all(Size(375.0, 36.0)),
                          ),
                          onPressed: () async {
                            await _applyFriendListController.agreeFriendApply(userModel.id);
                            ToastUtil.show("已同意");
                          },
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          child: Text("拒绝", style: TextStyle(fontSize: 14)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0)),
                            minimumSize: MaterialStateProperty.all(Size(0, 0)),
                            maximumSize: MaterialStateProperty.all(Size(375.0, 36.0)),
                          ),
                          onPressed: () async {
                            await _applyFriendListController.refuseFriendApply(userModel.id);
                            ToastUtil.show("已同意");
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: _applyFriendListController.applyUserList.length,
        ),
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Colors.green),
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
