import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import 'package:common_utils_v2/common_utils_v2.dart';


class UserAvatarWidget extends StatelessWidget {
  final String avatarPath;
  final String avatarName;
  final double radius;

  const UserAvatarWidget({required this.radius, required this.avatarName, required this.avatarPath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center, width: 49, height: 49,
      child: TextUtil.isNotEmpty(avatarPath)
          ? ClipRRect(child: Image.network(avatarPath, width: 39, height: 39, fit: BoxFit.fill), borderRadius: BorderRadius.circular(radius))
          : ClipRRect(child: Container( alignment: Alignment.center,width: 39, height: 39, color: Get.theme.primaryColor, child: Text(avatarName.substring(0,1), style: const TextStyle(fontSize: 20, color: Colors.white))), borderRadius: BorderRadius.circular(radius))
    );
  }
}
