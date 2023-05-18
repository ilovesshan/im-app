import 'package:flutter/material.dart';

typedef OnMessageItemClick = void Function(int messageId);


class MessageItem extends StatelessWidget {
  // final OnMessageItemClick onMessageItemClick;
  // const MessageItem(this.onMessageItemClick,{Key? key}) : super(key: key);
  const MessageItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child:Image.network("https://avatars.githubusercontent.com/u/63763453?v=4", width: 40, height: 40),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ilovesshan",style: TextStyle(fontSize: 14, color: Color(0xff000000), overflow: TextOverflow.ellipsis), maxLines: 1, softWrap: true,),
                    Text("2023-05-01", style: TextStyle(fontSize: 10, color: Color(0xff999999), overflow: TextOverflow.ellipsis), maxLines: 1, softWrap: true,),
                  ],
                ),
                SizedBox(height: 2),
                Text("大佬，明天教我手写Spring源码~", style: TextStyle(fontSize: 12, color: Color(0xff444444), overflow: TextOverflow.ellipsis), maxLines: 1, softWrap: true,),
              ],
            ),
          )
        ],
      ),
    );
  }
}
