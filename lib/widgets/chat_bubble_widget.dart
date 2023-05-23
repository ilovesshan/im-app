import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:common_utils_v2/common_utils_v2.dart';
import 'package:im/widgets/user_avatar_widget.dart';

class ChatBubbleWidget extends StatelessWidget {
  final String mNickname;
  final String yNickname;

  final String mAvatarUrl;
  final String yAvatarUrl;
  final String text;
  final bool isCurrentUser;

  const ChatBubbleWidget({
    required this.text, required this.isCurrentUser, required this.mAvatarUrl, required this.yAvatarUrl,
    this.mNickname = "", this.yNickname = "", Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: isCurrentUser? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          !isCurrentUser ? UserAvatarWidget(avatarPath: yAvatarUrl, avatarName: TextUtil.isEmptyWith(yNickname, "IM"), radius: 20): SizedBox(width: 40),

          Expanded(
            child: Wrap(
              alignment: isCurrentUser?  WrapAlignment.end : WrapAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  decoration: BoxDecoration(
                    color: isCurrentUser? Get.theme.primaryColor : Color(0xffe2e7eb),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(text, style: TextStyle(color: isCurrentUser? Colors.white : Colors.black), textAlign: isCurrentUser? TextAlign.right : TextAlign.left),
                ),
              ],
            ),
          ),
          isCurrentUser ? UserAvatarWidget(avatarPath:  mAvatarUrl, avatarName: TextUtil.isEmptyWith(mNickname, "IM"), radius: 20): SizedBox(width: 40),
        ],
      ),
    );
  }
}
