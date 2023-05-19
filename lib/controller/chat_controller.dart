import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im/api/api.dart';
import 'package:im/model/chat_model.dart';

class ChatController extends GetxController {
  late List<ChatModel> _chatModelList = [];
  late TextEditingController _messageTextEditingController;


  List<ChatModel> get chatModel => _chatModelList;
  TextEditingController get messageTextEditingController => _messageTextEditingController;


  @override
  void onInit() {
    super.onInit();
    _messageTextEditingController = TextEditingController();
  }

  /// 查询聊天记录列表
  Future<void> queryChatList(int fid) async {
    final ChatModel chatModel = await Api.queryChatList(fid);
    _chatModelList.clear();
    _chatModelList.add(chatModel);
    update();
  }

  /// 发送消息
  void sendMessage(int fid) async{
    Map<String, Object> requestBody ={
      "type": 0,
      "to": fid,
      "content": _messageTextEditingController.text
    };
    await Api.sendMessage(requestBody);

    _messageTextEditingController.text = "";

    // 刷新聊天记录
    queryChatList(fid);
  }
}
