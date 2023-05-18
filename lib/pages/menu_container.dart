import 'package:flutter/material.dart';
import 'package:bruno/bruno.dart';
import 'package:im/pages/friend_page.dart';
import 'package:im/pages/world_page.dart';

import 'message_page.dart';

class MenuContainerPage extends StatefulWidget {
  const MenuContainerPage({Key? key}) : super(key: key);

  @override
  State<MenuContainerPage> createState() => _MenuContainerPageState();
}

class _MenuContainerPageState extends State<MenuContainerPage> {
  var _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<BrnBottomTabBarItem> _brnBottomTabBarItem = [
    BrnBottomTabBarItem(icon: Icon(Icons.message_outlined), title: Text("消息")),
    BrnBottomTabBarItem(icon: Icon(Icons.people_alt_outlined), title: Text("朋友")),
    BrnBottomTabBarItem(icon: Icon(Icons.dynamic_feed_outlined), title: Text("小世界")),
  ];

  final List<Widget> _pages = [MessagePage(), FriendPage(), WorldPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            _currentIndex = index;
            setState(() {});
          },
          children: _pages,
        ),
        bottomNavigationBar: BrnBottomTabBar(
          fixedColor: Colors.blue,
          currentIndex: _currentIndex,
          onTap: (index) {
            _pageController.jumpToPage(index);
            _currentIndex = index;
            setState(() {});
          },
          badgeColor: Colors.red,
          items: _brnBottomTabBarItem
        )
    );
  }
}
