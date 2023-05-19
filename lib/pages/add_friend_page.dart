import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:im/controller/add_friend_controller.dart';
import 'package:im/controller/friend_list_controller.dart';
import 'package:im/model/user_model.dart';
import 'package:im/widgets/user_avatar_widget.dart';

class AddFriendPage extends StatelessWidget {
  AddFriendPage({Key? key}) : super(key: key);

  AddFriendListController _friendController = Get.put(AddFriendListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加朋友"),
        centerTitle: true,elevation: 0,
        actions: [Container(margin: EdgeInsets.only(right: 20), child: Image.asset("assets/images/scan.png", width: 24, height: 26),)],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: TextField(
                      controller: _friendController.kwTextEditingController,
                      decoration:new InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Get.theme.primaryColor, width: 1.0)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe2e7eb), width: 1.0)),
                        hintText: '输入昵称/IM号',
                      ),
                    )
                ),
                SizedBox(width: 5),
                ElevatedButton(child: Text("搜索"),onPressed: (){
                  _friendController.searchUserList();
                })
              ],
            ),

            SizedBox(height: 10),

            Expanded(child:GetBuilder<AddFriendListController>(
              init: _friendController,
              builder: (_){
                return ListView.builder(itemBuilder: (context, index){
                  final UserModel userModel = _friendController.searchResultUserList[index];
                  return Container(
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xffefefef)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        UserAvatarWidget(avatarName: userModel.username, avatarPath: userModel.image, radius: 20),
                        Expanded(child: Padding(padding: EdgeInsets.only(left: 20),child: Text(userModel.username, style: TextStyle(fontSize: 16), textAlign: TextAlign.left))),
                        ElevatedButton(
                          child: Text("添加",style: TextStyle(fontSize: 14)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.green),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0),),),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0)),
                            minimumSize: MaterialStateProperty.all(Size(0, 0)),
                            maximumSize: MaterialStateProperty.all(Size(375.0, 36.0)),
                          ),
                          onPressed: (){
                            _friendController.addFriend(userModel.id);
                          }
                        )
                      ],
                    ),
                  );
                }, itemCount: _friendController.searchResultUserList.length);
              }
            ))
          ],
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
