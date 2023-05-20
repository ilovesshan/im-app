import 'package:flutter/material.dart';
import 'package:im/model/recently_message_model.dart';
import 'package:im/widgets/user_avatar_widget.dart';

typedef OnMessageItemClick = void Function(int messageId);


class RecentlyMessageItem extends StatelessWidget {
  RecentlyMessageModel recentlyMessageModel;

  RecentlyMessageItem({required this.recentlyMessageModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          UserAvatarWidget(radius: 20, avatarName: recentlyMessageModel.username, avatarPath: recentlyMessageModel.image),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(recentlyMessageModel.username,style: TextStyle(fontSize: 14, color: Color(0xff000000), overflow: TextOverflow.ellipsis), maxLines: 1, softWrap: true,),
                    Text(recentlyMessageModel.time, style: TextStyle(fontSize: 10, color: Color(0xff999999), overflow: TextOverflow.ellipsis), maxLines: 1, softWrap: true,),
                  ],
                ),
                SizedBox(height: 2),
                Text(recentlyMessageModel.content, style: TextStyle(fontSize: 12, color: Color(0xff444444), overflow: TextOverflow.ellipsis), maxLines: 1, softWrap: true,),
              ],
            ),
          )
        ],
      ),
    );
  }
}
