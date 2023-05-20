import 'dart:convert';
import 'package:get/get.dart';
import 'package:im/controller/chat_controller.dart';
import 'package:uuid/uuid.dart';
import 'package:im/util/http_helper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class SocketController extends GetxController {
  final channel = WebSocketChannel.connect(Uri.parse(HttpHelper.baseWsUrl));

  final ChatController _chatController = Get.put(ChatController());

  @override
  void onInit() {
    super.onInit();
    print("SocketController onInit...");
    channel.stream.listen((message) {
     Map<String, dynamic> responseData = json.decode(message);
     if(responseData !=null && responseData["type"] == "2"){
       String? fid = responseData["fid"];
        /// 消息推送
       _chatController.queryChatList(int.parse(fid!));
     }
    });
  }

  /// 发送消息(聊天)
  sendMessage(String message, int uid, int toId) {
    Map<String, String> sendData = {
      "type": "2",
      "uid": '$uid',
      "toId": '$toId',
      "message": message
    };
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
    print("SocketController 销毁...");
  }
}
