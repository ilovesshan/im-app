import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AddFriendPage extends StatelessWidget {
  const AddFriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加朋友"), centerTitle: true,elevation: 0,
          actions: [
            Container(margin: EdgeInsets.only(right: 20), child: Image.asset("assets/images/scan.png", width: 24, height: 26),)
          ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: TextField(
                      decoration:new InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Get.theme.primaryColor, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffe2e7eb), width: 1.0),
                        ),
                        hintText: '输入昵称/IM号',
                      ),
                    )
                ),

                SizedBox(width: 5),

                GestureDetector(
                  child: Container(
                    width: 60, height: 36, alignment: Alignment.center, decoration: BoxDecoration( color: Get.theme.primaryColor, borderRadius: BorderRadius.circular(6)),
                    child: Text("搜索", style: TextStyle(color: Colors.white)),
                  ),
                  onTap: (){
                    EasyLoading.showToast('搜索...');
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
