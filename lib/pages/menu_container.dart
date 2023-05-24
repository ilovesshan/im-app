import 'package:flutter/material.dart';

import 'package:bruno/bruno.dart';
import 'package:common_utils_v2/common_utils_v2.dart';
import 'package:im/pages/friend_page.dart';
import 'package:im/pages/message_page.dart';

import 'package:im/pages/profile.dart';
import 'package:im/pages/world_page.dart';



class MenuContainerPage extends StatefulWidget{
  const MenuContainerPage({Key? key}) : super(key: key);
  @override
  State<MenuContainerPage> createState() => _MenuContainerPageState();
}

class _MenuContainerPageState extends State<MenuContainerPage> with SingleTickerProviderStateMixin {
  var _currentIndex = 0;
  late TabController _tabController;

  final List<BrnBottomTabBarItem> _brnBottomTabBarItem = [
    BrnBottomTabBarItem(icon: Icon(Icons.message_outlined), title: Text("消息")),
    BrnBottomTabBarItem(icon: Icon(Icons.perm_contact_cal_rounded), title: Text("朋友")),
    BrnBottomTabBarItem(icon: Icon(Icons.settings_input_svideo_outlined), title: Text("小世界")),
    BrnBottomTabBarItem(icon: Icon(Icons.person_outline_outlined), title: Text("我的")),
  ];

  final List<Widget> _pages = [MessagePage(), FriendPage(), WorldPage(), ProfilePage()];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _brnBottomTabBarItem.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          // controller: _pageController,
          // onPageChanged: (index) {
          //   _currentIndex = index;
          //   setState(() {});
          // },
          children: _pages,
        ),
        bottomNavigationBar: BrnBottomTabBar(
          fixedColor: Colors.blue,
          currentIndex: _currentIndex,
          onTap: (index) {
            _tabController.animateTo(index);
            _currentIndex = index;
            setState(() {});
          },
          badgeColor: Colors.red,
          items: _brnBottomTabBarItem
        )
    );
  }
}
