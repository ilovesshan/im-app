import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im/controller/socket_controller.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:im/controller/chat_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:im/model/chat_model.dart';
import 'package:im/util/text_util.dart';
import 'package:im/widgets/user_avatar_widget.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);

  final ChatController _chatController = Get.find<ChatController>();
  final SocketController _socketController = Get.find<SocketController>();

  // final ChatController _chatController = Get.put<ChatController>(ChatController());
  // final SocketController _socketController = Get.put<SocketController>(SocketController());

  @override
  Widget build(BuildContext context) {
    var fid = Get.parameters['fid'];
    var uid = Get.parameters['uid'];
    var name = Get.parameters['name'];

    _chatController.queryChatList(int.parse(fid!));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,elevation: 2, backgroundColor: Colors.white,
        title: Text(name!, style: TextStyle(color: Colors.black)),
        leading: GestureDetector(child: Icon(Icons.arrow_back, color: Colors.black), onTap: ()=> Get.back()),
      ),
      body: GetBuilder<ChatController>(
        init: _chatController,
        builder: (_){
          return _chatController.chatModel.length == 0
            ? Text("加载中...")
            : Column(
                children: [
                  // 聊天列表
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(itemBuilder: (context, index) {
                        ChatModel chatModel =  _chatController.chatModel[0];
                        Message message = chatModel.message[index];
                        return JustTheTooltip(
                          backgroundColor: Color(0xff4b4c4e),
                          showDuration: Duration(seconds: 20),
                          child: ChatBubble(
                            mAvatarUrl: chatModel.muser.image,
                            yAvatarUrl: chatModel.yuser.image,
                            text: message.content,
                            isCurrentUser:  message.from == int.parse(uid!),
                          ),
                          content: Container(
                            width: 150,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  GestureDetector(child: Text("撤回", style: TextStyle(color: Color(0xffd8d8da)))),
                                  SizedBox(width: 10)
                                  ,Text("删除", style: TextStyle(color: Color(0xffd8d8da))),
                                  SizedBox(width: 10),
                                  Text("复制", style: TextStyle(color: Color(0xffd8d8da))),
                                ],
                              ),
                            ),
                          ),
                        );
                      }, itemCount: ( _chatController.chatModel[0].message.length), controller: _chatController.listViewController,),
                    ),
                  ),
                  // 内容输入框
                  Container(
                    width: Get.width,
                    color: Colors.white,
                    // height: 50,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                              maxLines: 4, minLines: 1, controller: _chatController.messageTextEditingController,
                              decoration:new InputDecoration(
                                contentPadding: EdgeInsets.all(8), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Get.theme.primaryColor, width: 1.0)),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe2e7eb), width: 1.0)),
                                hintText: '',
                              ),
                            )
                        ),

                        SizedBox(width: 5),

                        GestureDetector(
                          child: Container(
                            width: 60, height: 36, alignment: Alignment.center, decoration: BoxDecoration( color: Get.theme.primaryColor, borderRadius: BorderRadius.circular(6)),
                            child: Text("发送", style: TextStyle(color: Colors.white)),
                          ),
                          onTap: () async {
                            final message = await _chatController.sendMessage(int.parse(fid));
                            _socketController.sendMessage(message, int.parse(uid!), int.parse(fid));
                          },
                        )
                      ],
                    ),
                  )
                ],
          );
        },
      )
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String mNickname;
  final String yNickname;

  final String mAvatarUrl;
  final String yAvatarUrl;
  final String text;
  final bool isCurrentUser;

  const ChatBubble({
    required this.text, required this.isCurrentUser, required this.mAvatarUrl, required this.yAvatarUrl,
    this.mNickname = "", this.yNickname = "", Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: isCurrentUser? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          !isCurrentUser ? UserAvatarWidget(avatarPath: yAvatarUrl, avatarName: TextUtils.isEmptyWith(yNickname, "IM"), radius: 20): SizedBox(width: 40),

          Expanded(
            child: Wrap(
            alignment: isCurrentUser?  WrapAlignment.end : WrapAlignment.start,
             children: [
               Container(
                 margin: EdgeInsets.symmetric(horizontal: 6),
                 padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                 decoration: BoxDecoration(
                   color: isCurrentUser? Get.theme.primaryColor : Color(0xffe2e7eb),
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child: Text(text, style: TextStyle(color: isCurrentUser? Colors.white : Colors.black), textAlign: isCurrentUser? TextAlign.right : TextAlign.left),
               ),
             ],
            ),
          ),
          isCurrentUser ? UserAvatarWidget(avatarPath:  mAvatarUrl, avatarName: TextUtils.isEmptyWith(mNickname, "IM"), radius: 20): SizedBox(width: 40),
        ],
      ),
    );
  }
}

