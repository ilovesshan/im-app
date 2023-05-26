import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:im/pages/add_friend_page.dart';
import 'package:im/pages/chat_page.dart';
import 'package:im/pages/friend_apply_page.dart';
import 'package:im/pages/login.dart';
import 'package:im/pages/menu_container.dart';

class AppRouter {
  static const String initRoute = login;

  static const String login = "/login";
  static const String menuContainer = "/menuContainer";
  static const String chat = "/chat";
  static const String addFriend = "/addFriend";
  static const String friendApply = "/friendApply";

  /// 路由表
  static List<GetPage> routes() {
    return [
      GetPage(name: login, page: () => LoginPage()),
      GetPage(name: menuContainer, page: () => MenuContainerPage()),
      GetPage(name: chat, page: () => ChatPage()),
      GetPage(name: addFriend, page: () => AddFriendPage()),
      GetPage(name: friendApply, page: () => FriendApplyPage()),
    ];
  }

  /// 404路由
  static Route<dynamic>? onUnknownRoute(RouteSettings routeSettings) {
    return MaterialPageRoute<void>(
      settings: routeSettings,
      builder: (BuildContext context) => const Scaffold(body: Center(child: Text('Not Found'))),
    );
  }

  /// 路由拦截
  static ValueChanged<Routing?>? routingCallback(Routing routing) {
    if (routing.current == AppRouter.menuContainer) {
      /// 做业务处理...
    }
  }
}
