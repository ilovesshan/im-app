import 'dart:ui';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/constants.dart' as MtConstants;

import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/controller/chat_controller.dart';
import 'package:im/controller/socket_controller.dart';
import 'package:im/model/chat_model.dart';
import 'package:im/widgets/chat_bubble_widget.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);

  /// 注入控制器
  final ChatController _chatController = Get.put(ChatController());

  /// 用于确定到取消按钮的位置
  final GlobalKey _cancelWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        title: Obx(()=>Text(_chatController.fname, style: TextStyle(color: Colors.black))),
        leading: GestureDetector(child: Icon(Icons.arrow_back, color: Colors.black), onTap: () => Get.back()),
      ),
      body: Obx(() => _chatController.chatModel.length == 0
        ? Center(child: Text("加载中..."))
        : SingleChildScrollView(
          child: Column(
            children: [
              /// 语音输入窗口 Widget
              Stack(
                children: [
                  Offstage(
                    offstage: _chatController.isHidden,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            width: Get.width,
                            height: Get.height - (MtConstants.kToolbarHeight + Get.window.padding.top + 10),
                            color: Colors.black.withOpacity(0.2),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(height: 80),
                                  Container(
                                    width: 140,
                                    height: 60,
                                    padding: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                      children: [
                                        Icon(Icons.mic_rounded, color: Colors.white),
                                        Text(_chatController.microphoneIconText, style: TextStyle(fontSize: 14, color: Colors.white))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    key: _cancelWidgetKey,
                                    width: 80,
                                    height: 80,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(color: _chatController.cancelWidgetColor, borderRadius: BorderRadius.circular(60)),
                                    child: Icon(Icons.clear, color: Colors.white, size: 30),
                                  )
                                ],
                              ),
                            ),
                          ),

                          /// 隐藏聊天Widget并展示录音Widget
                          onTap: () => _chatController.isHidden = false,
                        ),
                        GestureDetector(
                          child: Container(
                            width: Get.width,
                            height: 60,
                            alignment: Alignment.center,
                            color: Colors.blue,
                            child: Text(_chatController.bottomWidgetText, style: TextStyle(color: Colors.white)),
                          ),

                          /// 手指按下 开始录音
                          onLongPress: () => _chatController.startRecorder(),

                          /// 手指离开 停止录音
                          onLongPressUp: () => _chatController.stopRecorder(),

                          /// 手指滑动 需要记录当前手指所处位置(方便离开时判断是否在取消按钮区域内)
                          onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) => _chatController.onFingerMove(details, _cancelWidgetKey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// 聊天窗口 Widget
              Offstage(
                offstage: !_chatController.isHidden,
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      /// 聊天列表
                      Container(
                        width: Get.width,
                        height: Get.height - (MtConstants.kToolbarHeight +Get.window.padding.top + 10),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              ChatModel chatModel = _chatController.chatModel[0];
                              Message message = chatModel.message[index];
                              return JustTheTooltip(
                                backgroundColor: Color(0xff4b4c4e),
                                showDuration: Duration(seconds: 20),
                                child: ChatBubbleWidget(
                                  mAvatarUrl: chatModel.muser.image,
                                  yAvatarUrl: chatModel.yuser.image,
                                  text: message.type != 1 ? HttpHelperUtil.baseurl + message.content : message.content,
                                  isCurrentUser: message.from == int.parse(_chatController.uid),
                                  type: message.type,
                                ),
                                content: Container(
                                  width: 150,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        GestureDetector(child: Text("撤回", style: TextStyle(color: Color(0xffd8d8da)))),
                                        SizedBox(width: 10),
                                        Text("删除", style: TextStyle(color: Color(0xffd8d8da))),
                                        SizedBox(width: 10),
                                        Text("复制", style: TextStyle(color: Color(0xffd8d8da))),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: (_chatController.chatModel[0].message.length),
                            controller: _chatController.listViewController,
                          ),
                        ),
                      ),

                      /// 底部操作按钮
                      Container(
                        width: Get.width,
                        color: Colors.white,
                        height: 50,
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          children: [
                            GestureDetector(
                              child: Container(
                                  width: 36,
                                  height: 36,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Get.theme.primaryColor, borderRadius: BorderRadius.circular(36)),
                                  child: Icon(Icons.mic, color: Colors.white, size: 20)
                              ),

                              /// 录音按钮被点击 隐藏聊天Widget显示录音的Widget
                              onTap: () => _chatController.isHidden = false,
                            ),

                            SizedBox(width: 5),

                            /// 文本输入框
                            Expanded(
                              child: TextField(
                                maxLines: 4,
                                minLines: 1,
                                controller: _chatController.messageTextEditingController,
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Get.theme.primaryColor, width: 1.0)),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe2e7eb), width: 1.0)),
                                  hintText: '',
                                ),
                              ),
                            ),
                            SizedBox(width: 5),

                            /// 发送按钮
                            GestureDetector(
                              child: Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Get.theme.primaryColor, borderRadius: BorderRadius.circular(36)),
                                child: Icon(_chatController.isOptionsBtn ? Icons.add_circle_outline_outlined : Icons.send, color: Colors.white, size: 20),
                              ),
                              onTap: () async {
                                if (!_chatController.isOptionsBtn) {
                                  /// 发送信息
                                  await _chatController.sendTextMessage();
                                } else {
                                  /// 弹出底部选项菜单
                                  CommonBottomSheetSelector.showIconItem(
                                    data: CommonBottomSheetConstants.commonBottomSheetIconList,
                                    onResult: (id) async {
                                      switch (id) {
                                        case "1":
                                          final pickPath = await ImagePickerUtil.pick(isCamera: false);
                                          printLog(StackTrace.current, "相册选取上传=====》 $pickPath");
                                          BrnLoadingDialog.show(context);
                                          await _chatController.uploadLoadMediaAndSendMessage(mediaPath: pickPath, type: 2);
                                          BrnLoadingDialog.dismiss(context);
                                          break;
                                        case "2":
                                          final pickPath = await ImagePickerUtil.pick(isCamera: true);
                                          BrnLoadingDialog.show(context);
                                          printLog(StackTrace.current, "拍照上传=====》 $pickPath");
                                          await _chatController.uploadLoadMediaAndSendMessage(mediaPath: pickPath, type: 2);
                                          BrnLoadingDialog.dismiss(context);
                                          break;
                                        case "3":
                                          ToastUtil.show("语音通话");
                                          break;
                                        case "4":
                                          ToastUtil.show("视频通话");
                                          break;
                                        case "5":
                                          ToastUtil.show("发红包");
                                          break;
                                        case "6":
                                          ToastUtil.show("戳一戳");
                                          break;
                                      }
                                    },);
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}