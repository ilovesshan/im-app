import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im/api/api.dart';
import 'package:im/model/chat_model.dart';

class ChatController extends GetxController {
  late List<ChatModel> _chatModelList = [];
  late ScrollController _scrollController;
  late TextEditingController _messageTextEditingController;


  List<ChatModel> get chatModel => _chatModelList;
  get listViewController => _scrollController;
  TextEditingController get messageTextEditingController => _messageTextEditingController;




  @override
  void onInit() {
    super.onInit();
    _scrollController = ScrollController();
    _messageTextEditingController = TextEditingController();
  }

  /// 查询聊天记录列表
  Future<void> queryChatList(int fid) async {
    final ChatModel chatModel = await Api.queryChatList(fid);
    _chatModelList.clear();
    _chatModelList.add(chatModel);
    /// 延迟500毫秒，再进行滑动
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    update();
  }

  /// 发送消息
  Future<String> sendMessage(int fid) async{
    String message = _messageTextEditingController.text;
    Map<String, Object> requestBody ={
      "type": 0,
      "to": fid,
      "content": message
    };
    await Api.sendMessage(requestBody);
    // 刷新聊天记录
    queryChatList(fid);
    _messageTextEditingController.text = "";
    return message;
  }
}
