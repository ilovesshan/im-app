import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/controller/chat_controller.dart';
import 'package:im/controller/socket_controller.dart';
import 'package:im/model/chat_model.dart';
import 'package:im/widgets/chat_bubble_widget.dart';



class ChatPage extends StatefulWidget {
  ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>  with WidgetsBindingObserver{
  final ChatController _chatController = Get.find<ChatController>();

  final SocketController _socketController = Get.find<SocketController>();

  /// 是否正在播放
  late bool _isPlaying = false;

  /// 是否正在录音
  late bool _isRecording = false;

  /// 底部Widget显示的文字
  String _bottomWidgetText = "按住说话";

  /// 麦克风图标显示的文字
  String _microphoneIconText = "按住说话";

  /// 是否隐藏语音输入界面
  bool _isHidden = true;

  /// 手指是否触摸大到取消按钮
  bool _fingerInCancelWidget = false;

  /// 取消按钮的背景颜色变化(手指触摸变红)
  Color _cancelWidgetColor = Colors.black.withOpacity(0.5);

  /// 用于确定到取消按钮的位置
  final GlobalKey _cancelWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    var fid = Get.parameters['fid'];
    _chatController.queryChatList(int.parse(fid!));
    RecordUtil.openRecorderBeforeInit();
  }


  @override
  void dispose() {
    super.dispose();
    RecordUtil.closeAudioSession();
  }

  @override
  Widget build(BuildContext context) {

    var uid = Get.parameters['uid'];
    var name = Get.parameters['name'];
    var fid = Get.parameters['fid'];

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
            ? Center(child: Text("加载中..."))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    /// 语音输入窗口 Widget
                    Stack(
                      children: [
                        Offstage(
                          offstage: _isHidden,
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height - (kToolbarHeight + MediaQueryData.fromWindow(window).padding.top + 60),
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
                                              Text(_microphoneIconText, style: TextStyle(fontSize: 14, color: Colors.white))
                                            ],
                                          ),
                                        ),
                                        Container(
                                            key: _cancelWidgetKey,
                                            width: 80,
                                            height: 80,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(color: _cancelWidgetColor, borderRadius: BorderRadius.circular(60)),
                                            child: Icon(Icons.clear, color: Colors.white, size: 30)
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  _isHidden = true;
                                  setState(() {});
                                },
                              ),

                              GestureDetector(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60, alignment: Alignment.center,
                                  color: Colors.blue,
                                  child: Text(_bottomWidgetText, style: TextStyle(color: Colors.white)),
                                ),
                                onLongPress: () async {
                                  _isHidden = false;
                                  _bottomWidgetText = "上滑取消/离开发送";
                                  _microphoneIconText = "倾听中...";
                                  setState(() {});

                                  /// 开始录音
                                  startRecorder();
                                },
                                onLongPressUp: (){
                                  _isHidden = true;
                                  _bottomWidgetText = "按住说话";
                                  _microphoneIconText ="按住说话";
                                  if(_fingerInCancelWidget){
                                    Fluttertoast.showToast(msg: "取消...");
                                  }else{
                                    /// 停止录音, 上传录音信息到服务器
                                    RecordUtil.stopRecorder(onResultCallBack: (path) async {
                                      _isRecording = false;
                                      final Map<String, dynamic> uploadResponse = await FileUploadUtil.uploadSingle(filePath: path);
                                      /// 发送聊天记录
                                      _chatController.sendMediaMessage(fid: int.parse(fid!), type: 3, mediaPath: uploadResponse["path"]);
                                      _chatController.queryChatList(int.parse(fid));
                                      /// 通过Socket向服务器发送消息
                                      _socketController.sendMessage(uploadResponse["path"], int.parse(uid!), int.parse(fid));
                                      setState(() {});
                                    });
                                  }
                                  setState(() {});
                                },
                                onLongPressMoveUpdate: (LongPressMoveUpdateDetails details){
                                  /// 当前手指滑动的位置
                                  Offset globalOffset = details.globalPosition;

                                  /// 取消按钮的位置以及宽高信息
                                  RenderBox renderBox = _cancelWidgetKey.currentContext!.findRenderObject() as RenderBox;
                                  Offset cancelBtnOffset =  renderBox.localToGlobal(Offset.zero);
                                  Size cancelBtnSize = renderBox.size;

                                  /// 判断手指位置是滑动到取消按钮之内
                                  bool horizontalInTarget = globalOffset.dx >= cancelBtnOffset.dx && globalOffset.dx <= cancelBtnOffset.dx + cancelBtnSize.width;
                                  bool verticalInTarget = globalOffset.dy >= cancelBtnOffset.dy && globalOffset.dy <= cancelBtnOffset.dy + cancelBtnSize.height;

                                  if(horizontalInTarget && verticalInTarget){
                                    /// 手指滑动到取消按钮区域内
                                    _cancelWidgetColor = Colors.red.withOpacity(1);
                                    _fingerInCancelWidget = true;
                                  }else{
                                    _fingerInCancelWidget = false;
                                    _cancelWidgetColor = Colors.black.withOpacity(0.5);
                                  }
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    /// 聊天窗口 Widget
                    Offstage(
                      offstage: !_isHidden,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            /// 聊天列表
                            Container(
                              width: Get.width,
                              // 327
                              height: Get.height - (kToolbarHeight + MediaQueryData.fromWindow(window).padding.top + 60),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: ListView.builder(itemBuilder: (context, index) {
                                  ChatModel chatModel =  _chatController.chatModel[0];
                                  Message message = chatModel.message[index];
                                  return JustTheTooltip(
                                    backgroundColor: Color(0xff4b4c4e),
                                    showDuration: Duration(seconds: 20),
                                    child: ChatBubbleWidget(
                                      mAvatarUrl: chatModel.muser.image,
                                      yAvatarUrl: chatModel.yuser.image,
                                      text:  message.type!=1 ? HttpHelperUtil.baseurl + message.content : message.content,
                                      isCurrentUser:  message.from == int.parse(uid!),
                                      type: message.type,
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
                                      width: 36, height: 36, alignment: Alignment.center, decoration: BoxDecoration( color: Get.theme.primaryColor, borderRadius: BorderRadius.circular(36)),
                                      child: Icon(Icons.mic, color: Colors.white, size: 20),
                                    ),
                                    onTap: () async {
                                      /// 申请权限
                                      _isHidden = false;
                                      setState(() {});
                                    },
                                  ),

                                  SizedBox(width: 5),

                                  /// 文本输入框
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

                                  /// 发送按钮
                                  GestureDetector(
                                    child: Container(
                                      width: 36, height: 36, alignment: Alignment.center, decoration: BoxDecoration( color: Get.theme.primaryColor, borderRadius: BorderRadius.circular(36)),
                                      child: Icon(Icons.send, color: Colors.white, size: 20),
                                    ),
                                    onTap: () async {
                                      final message = await _chatController.sendTextMessage(int.parse(fid!));
                                      /// 通过Socket向服务器发送消息
                                      _socketController.sendMessage(message, int.parse(uid!), int.parse(fid));
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
          );
        },
      )
    );
  }

  void startRecorder() {
    RecordUtil.startRecorder(onResultCallBack: (){
      _isRecording = true;
      setState(() {});
    });
  }

  void play() async {
    _isPlaying = true;
    setState(() {});
    RecordUtil.playRecorder(onResultCallBack: (){
      Fluttertoast.showToast(msg: "播放结束");
      _isPlaying = false;
      RecordUtil.closeAudioSession();
      setState(() {});
    });
  }

  void stopRecorder() async {

  }
}
