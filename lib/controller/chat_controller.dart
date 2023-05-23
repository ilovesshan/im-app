import 'package:flutter/material.dart';

import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/api/api.dart';
import 'package:im/model/chat_model.dart';

class ChatController extends GetxController {
  /// 聊天记录
  late final List<ChatModel> _chatModelList = [];
  /// Listview 控制器
  late final ScrollController _scrollController = ScrollController();
  /// 聊天文本信息控制器
  late final TextEditingController _messageTextEditingController = TextEditingController();
  /// 显示选项按钮(默认)还是发送按钮
  bool _isOptionsBtn = true;

  List<ChatModel> get chatModel => _chatModelList;
  ScrollController get listViewController => _scrollController;
  TextEditingController get messageTextEditingController => _messageTextEditingController;
  bool get isOptionsBtn => _isOptionsBtn;


  @override
  void onInit() {
    super.onInit();
    /// 监听_messageTextEditingController内容改变
    _messageTextEditingController.addListener(() {
      if(_messageTextEditingController.text.isEmpty){
        _isOptionsBtn = true;
      }else{
        _isOptionsBtn = false;
      }
      update();
    });
  }

  /// 查询聊天记录列表
  Future<void> queryChatList(int fid) async {
    final ChatModel chatModel = await Api.queryChatList(fid);
    _chatModelList.clear();
    _chatModelList.add(chatModel);
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
