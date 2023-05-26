import 'dart:convert';
import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/controller/chat_controller.dart';
import 'message_controller.dart';

class SocketController extends GetxController {
  final channel = WebSocketChannel.connect(Uri.parse(HttpHelperUtil.baseWsUrl));

  @override
  void onInit() {
    super.onInit();
    channel.stream.listen((message) {
      Map<String, dynamic> responseData = json.decode(message);
      if (responseData != null && responseData["type"] == "2") {
        /// 获取朋友ID
        String? fid = responseData["fid"];

        /// 获取对应Controller
        final ChatController _chatController = Get.put(ChatController());
        final MessageController _messageController = Get.put(MessageController());

        /// 更新消息(聊天记录界面)
        String? userId = SpUtil.getValue("userId");
        if (userId != fid) {
          _chatController.queryChatList(int.parse(fid!));
        }

        /// 更新消息(首页界面)
        _messageController.queryRecentlyMessageList();
      }
    });
  }

  /// 发送消息(聊天)
  sendMessage(String message, int uid, int toId) {
    Map<String, String> sendData = {"type": "2", "uid": '$uid', "toId": '$toId', "message": message};
    channel.sink.add(json.encode(sendData));
  }

  /// 用户上线
  userLogin(int uid) {
    Map<String, String> sendData = {"type": "1", "uid": "$uid"};
    channel.sink.add(json.encode(sendData));
  }

  /// 用户下线
  void logout(int id) {
    Map<String, String> sendData = {"type": "0", "uid": "$id"};
    channel.sink.add(json.encode(sendData));
  }

  /// 关闭Socket
  closeSocket() {
    channel.sink.close();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
