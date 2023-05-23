import 'package:flutter/material.dart';

import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/api/api.dart';
import 'package:im/model/chat_model.dart';

class ChatController extends GetxController {
  late final List<ChatModel> _chatModelList = [];
  var ind = 0.obs;
  late final ScrollController _scrollController = ScrollController();
  late final TextEditingController _messageTextEditingController = TextEditingController();

  List<ChatModel> get chatModel => _chatModelList;

  get listViewController => _scrollController;

  TextEditingController get messageTextEditingController => _messageTextEditingController;

  /// 查询聊天记录列表
  Future<void> queryChatList(int fid) async {
    final ChatModel chatModel = await Api.queryChatList(fid);
    _chatModelList.clear();
    _chatModelList.add(chatModel);
    ind.value = chatModel.message.length;
    update();

    /// 延迟500毫秒，再进行滑动
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  /// 发送消息
  Future<String> sendTextMessage(int fid) async {
    if (TextUtils.isEmpty(_messageTextEditingController.text)) {
      ToastUtils.show("请输入发送内容");
      return "";
    }
    String message = _messageTextEditingController.text;
    Map<String, Object> requestBody = {"type": 1, "to": fid, "content": message};
    await Api.sendMessage(requestBody);
    /// 刷新聊天记录
    queryChatList(fid);
    _messageTextEditingController.text = "";
    return message;
  }

  /// 发送消息
  Future<String> sendMediaMessage({required int fid, required int type, required String mediaPath}) async {
    Map<String, Object> requestBody = {"type": type, "to": fid, "content": mediaPath};
    await Api.sendMessage(requestBody);
    /// 刷新聊天记录
    queryChatList(fid);
    return mediaPath;
  }
}
