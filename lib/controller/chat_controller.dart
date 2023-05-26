import 'package:flutter/material.dart';

import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/api/api.dart';
import 'package:im/controller/socket_controller.dart';
import 'package:im/model/chat_model.dart';

class ChatController extends GetxController {
  /// 朋友ID(用于查询聊天记录)
  final _fid = (Get.parameters['fid'] as String).obs;
  /// 朋友名称(用于Tab展示)
  final _fname =  (Get.parameters['name'] as String).obs;
  /// 当前用户ID
  final _uid =  (Get.parameters['uid'] as String).obs;



  /// Listview 控制器
  final ScrollController _scrollController = ScrollController();

  /// 聊天文本信息控制器
  final TextEditingController _messageTextEditingController = TextEditingController();

  /// 聊天记录列表
  final List<ChatModel> _chatModelList = <ChatModel>[].obs;

  /// 显示选项按钮(默认)还是发送按钮
  final _isOptionsBtn = true.obs;

  /// 是否正在播放
  final _isPlaying = false.obs;

  /// 是否正在录音
  final _isRecording = false.obs;

  /// 底部Widget显示的文字
  final _bottomWidgetText = "按住说话".obs;

  /// 麦克风图标显示的文字
  final _microphoneIconText = "按住说话".obs;

  /// 是否隐藏语音输入界面
  final _isHidden = true.obs;

  /// 手指是否触摸大到取消按钮
  final _fingerInCancelWidget = false.obs;

  /// 取消按钮的背景颜色变化(手指触摸变红)
  final _cancelWidgetColor = Colors.black.withOpacity(0.5).obs;

  /// 提供Getter方法
  ScrollController get listViewController => _scrollController;

  TextEditingController get messageTextEditingController => _messageTextEditingController;

  List<ChatModel> get chatModel => _chatModelList;

  get fid => _fid.value;

  get fname => _fname.value;

  get uid => _uid.value;

  get isOptionsBtn => _isOptionsBtn.value;

  get isPlaying => _isPlaying.value;

  get isRecording => _isRecording.value;

  get bottomWidgetText => _bottomWidgetText.value;

  get microphoneIconText => _microphoneIconText.value;

  get isHidden => _isHidden.value;

  get fingerInCancelWidget => _fingerInCancelWidget.value;

  get cancelWidgetColor => _cancelWidgetColor.value;

  set isHidden(value) {
    _isHidden.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    /// 根据fid查询当前聊天记录
    queryChatList(int.parse(fid));

    /// 初始化录音工具
    RecordUtil.openRecorderBeforeInit();

    /// 监听_messageTextEditingController内容改变
    _messageTextEditingController.addListener(() {
      if (_messageTextEditingController.text.isEmpty) {
        _isOptionsBtn.value = true;
      } else {
        _isOptionsBtn.value = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    /// 关闭录音工具
    RecordUtil.closeAudioSession();
  }

  /// 查询聊天记录列表
  Future<void> queryChatList(int fid) async {
    final ChatModel chatModel = await Api.queryChatList(fid);
    _chatModelList.clear();
    _chatModelList.add(chatModel);

    /// 延迟500毫秒，再进行滑动
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  /// 发送文本消息
  Future<String> sendTextMessage() async {
    if (TextUtil.isEmpty(_messageTextEditingController.text)) {
      ToastUtil.show("请输入发送内容");
      return "";
    }
    String message = _messageTextEditingController.text;
    Map<String, Object> requestBody = {"type": 1, "to": fid, "content": message};
    await Api.sendMessage(requestBody);

    /// 刷新聊天记录
    queryChatList(int.parse(fid));

    // TODO: 应该由服务端主动推送（后期优化）
    /// 通过Socket向服务器发送消息
    final SocketController _socketController = Get.find<SocketController>();
    _socketController.sendMessage(_messageTextEditingController.text, int.parse(uid), int.parse(fid));
    _messageTextEditingController.text = "";
    return message;
  }

  /// 发送媒体(图片/音频)消息
  Future<String> sendMediaMessage({required int fid, required int type, required String mediaPath}) async {
    Map<String, Object> requestBody = {"type": type, "to": fid, "content": mediaPath};
    await Api.sendMessage(requestBody);

    /// 刷新聊天记录
    queryChatList(fid);
    return mediaPath;
  }

  /// 开始录音
  void startRecorder() {
    _isHidden.value = false;
    _bottomWidgetText.value = "上滑取消/离开发送";
    _microphoneIconText.value = "倾听中...";
    RecordUtil.startRecorder(onResultCallBack: () {
      _isRecording.value = true;
    });
  }

  /// 播放录音
  void play() async {
    _isPlaying.value = true;
    RecordUtil.playRecorder(onResultCallBack: () {
      ToastUtil.show("播放结束");
      _isPlaying.value = false;
      RecordUtil.closeAudioSession();
    });
  }

  /// 停止录音
  void stopRecorder() async {
    _isHidden.value = true;
    _bottomWidgetText.value = "按住说话";
    _microphoneIconText.value = "按住说话";
    if (_fingerInCancelWidget.value) {
      /// 当前手指位置处于取消按钮之上
      ToastUtil.show("取消...");
    } else {
      /// 停止录音, 上传录音信息到服务器
      RecordUtil.stopRecorder(onResultCallBack: (path) async {
        _isRecording.value = false;
        uploadLoadMediaAndSendMessage(mediaPath: path, type: 3);
      });
    }
  }

  /// 上传图片/录音 并推送聊天记录
  Future<void> uploadLoadMediaAndSendMessage({required String mediaPath, required int type}) async {
    final Map<String, dynamic> uploadResponse = await FileUploadUtil.uploadSingle(filePath: mediaPath);

    /// 发送聊天记录
    final ChatController _chatController = Get.find<ChatController>();
    _chatController.sendMediaMessage(fid: int.parse(fid), type: type, mediaPath: uploadResponse["path"]);
    _chatController.queryChatList(int.parse(fid));

    // TODO: 应该由服务端主动推送（后期优化）
    /// 通过Socket向服务器发送消息
    final SocketController _socketController = Get.find<SocketController>();
    _socketController.sendMessage(uploadResponse["path"], int.parse(uid), int.parse(fid));
  }

  /// 手指滑动处理(可能会做取消发生语音操作)
  void onFingerMove(LongPressMoveUpdateDetails details, GlobalKey cancelWidgetKey) {
    /// 当前手指滑动的位置
    Offset globalOffset = details.globalPosition;

    /// 取消按钮的位置以及宽高信息
    RenderBox renderBox = cancelWidgetKey.currentContext!.findRenderObject() as RenderBox;
    Offset cancelBtnOffset = renderBox.localToGlobal(Offset.zero);
    Size cancelBtnSize = renderBox.size;

    /// 判断手指位置是滑动到取消按钮之内
    bool horizontalInTarget = globalOffset.dx >= cancelBtnOffset.dx && globalOffset.dx <= cancelBtnOffset.dx + cancelBtnSize.width;
    bool verticalInTarget = globalOffset.dy >= cancelBtnOffset.dy && globalOffset.dy <= cancelBtnOffset.dy + cancelBtnSize.height;

    if (horizontalInTarget && verticalInTarget) {
      /// 手指滑动到取消按钮区域内(不发送语音)
      _cancelWidgetColor.value = Colors.red.withOpacity(1);
      _fingerInCancelWidget.value = true;
    } else {
      /// 手指未滑动到取消按钮区域内(要发送语音)
      _fingerInCancelWidget.value = false;
      _cancelWidgetColor.value = Colors.black.withOpacity(0.5);
    }
  }
}
