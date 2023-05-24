import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:flutter/material.dart';
import 'package:im/widgets/user_avatar_widget.dart';

class ChatBubbleWidget extends StatelessWidget {
  final String mNickname;
  final String yNickname;

  final String mAvatarUrl;
  final String yAvatarUrl;
  final int type;
  final String text;
  final bool isCurrentUser;

  const ChatBubbleWidget({
    required this.type, required this.text, required this.isCurrentUser, required this.mAvatarUrl, required this.yAvatarUrl,
    this.mNickname = "", this.yNickname = "", Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: type == 2 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: isCurrentUser? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          !isCurrentUser ? UserAvatarWidget(avatarPath: yAvatarUrl, avatarName: TextUtil.isEmptyWith(yNickname, "IM"), radius: 20): SizedBox(width: 40),
          Expanded(
            child: Wrap(
              alignment: isCurrentUser?  WrapAlignment.end : WrapAlignment.start,
              children: [
                buildChatBubbleContentByType(context, type)
              ],
            ),
          ),
          isCurrentUser ? UserAvatarWidget(avatarPath:  mAvatarUrl, avatarName: TextUtil.isEmptyWith(mNickname, "IM"), radius: 20): SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget buildChatBubbleContentByType (BuildContext context, int type){
    if(type == 1){
      // 文本
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 6),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(color: isCurrentUser? Theme.of(context).primaryColor: Color(0xffe2e7eb), borderRadius: BorderRadius.circular(8),),
          child: Text(text, style: TextStyle(color: isCurrentUser? Colors.white : Colors.black), textAlign: isCurrentUser? TextAlign.right : TextAlign.left)
      );
    }else if(type == 2){
      // 图片
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 6),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(color: isCurrentUser? Theme.of(context).primaryColor: Color(0xffe2e7eb), borderRadius: BorderRadius.circular(8),),
          child: ClipRRect(child: Image.network(text, width: 180, height: 200, fit: BoxFit.fill), borderRadius: BorderRadius.circular(5))
      );
    }else if(type == 3){
      // 语音
      return GestureDetector(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 6),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: isCurrentUser? Theme.of(context).primaryColor: Color(0xffe2e7eb), borderRadius: BorderRadius.circular(8),),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.mic, size: 20, color: isCurrentUser?  Colors.white: Theme.of(context).primaryColor),
                  Text("点击播放", style: TextStyle(fontSize: 12, color: isCurrentUser?  Colors.white: Theme.of(context).primaryColor))
                ]
            )
        ),
        onTap: () async {
          final path = await FileDownloadUtil.downLoadFile(text);
          ToastUtil.show( "开始播放");
          RecordUtil.playRecorder(recordSourcesPath: path, onResultCallBack: (){
            ToastUtil.show( "播放结束");
          });
        },
      );
      return Container();
    }else{
      return Container();
    }
  }
}