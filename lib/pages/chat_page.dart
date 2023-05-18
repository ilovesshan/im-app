import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:im/model/chat_model.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);

  final Map<String, Object> messageInfo =
    {
      "mUser":{
        "mNickname":"ilovesshan",
        "mAvatarUrl":"https://avatars.githubusercontent.com/u/63763453?v=4"
      },
      "yUser":{
        "yNickname":"一只小可爱",
        "yAvatarUrl":"https://avatars.githubusercontent.com/u/42670328?s=200&v=4"
      },
      "message":[
        {"text":"什么是Dart语言？", "isCurrentUser":true},
        {"text":"flutter为什么推荐使用Dart语言？","isCurrentUser":true},
        {"text":"Dart是一门面向对象（允许单继承）、垃圾回收的编程语言，它由google公司维护。", "isCurrentUser":false},
        {"text":"Dart是AOT（ahead of time）运行前编译，使用AOT语言的优点就是使Flutter具有更好的性能。Dart也可以通过JIR（just in time）即时编译，典型应用就是Flutter的热重载。Dart也允许FLutter使用JSX或者XML之类的作为界面构建的声明语言，这使得程序更易阅读和理解。", "isCurrentUser":false},
        {"text":"有了解过Dart事件循环机制吗？简单谈谈事件循环机制原理","isCurrentUser":true},
        {"text":"Dart 是基于事件循环机制的单线程模型, 所以 Dart 中没有多线程, 也就没有主线程与子线程之分，Dart单线程是通过消息循环机制来运行的，一共包含两个任务队列微任务队列（Microtask Queue）和事件队列（Event Queue）。Dart在执行完Main函数之后，Event Lopper就开始工作，Event Lopper会优先执行完Microtask Queue队列中的任务，直到Microtask Queue队列为空时才执行Event Queue中的任务，直到Event Queue为空时Event Lopper才能退出。", "isCurrentUser":false},
        {"text":"回答得不错明天来上班~","isCurrentUser":true},
      ],
    };
  @override
  Widget build(BuildContext context) {
    var messageId = Get.parameters['messageId'];
    ChatModel chatModel = ChatModel.fromJson(messageInfo);
    return Scaffold(
      appBar: AppBar(
          title: Text("用户 $messageId"), elevation: 0, centerTitle: true),
      body: Column(
        children: [
          // 聊天列表
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(itemBuilder: (context, index) {
                return ChatBubble(
                  mAvatarUrl: chatModel.mUser.mAvatarUrl,
                  yAvatarUrl:  chatModel.yUser.yAvatarUrl,
                  text:  chatModel.message[index].text,
                  isCurrentUser: chatModel.message[index].isCurrentUser,
                );}, itemCount: (chatModel.message.length)
              ),
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
                      maxLines: 4,
                      minLines: 1,
                      decoration:new InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Get.theme.primaryColor, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffe2e7eb), width: 1.0),
                        ),
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
                  onTap: (){
                    EasyLoading.showToast('发送消息...');
                  },
                )
              ],
            ),
          )
        ],
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
      // color: Colors.red,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isCurrentUser? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          !isCurrentUser ? ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child:Image.network(yAvatarUrl, width: 40, height: 40),
          ): SizedBox(width: 40),

          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                color: isCurrentUser? Get.theme.primaryColor : Color(0xffe2e7eb),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(text, style: TextStyle(color: isCurrentUser? Colors.white : Colors.black)),
            ),
          ),

          isCurrentUser ? ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child:Image.network(mAvatarUrl, width: 40, height: 40, fit: BoxFit.fill,),
          ): SizedBox(width: 40),
        ],
      ),
    );
  }
}

