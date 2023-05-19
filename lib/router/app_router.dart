import 'package:get/get.dart';
import 'package:im/pages/add_friend_page.dart';
import 'package:im/pages/chat_page.dart';
import 'package:im/pages/login.dart';
import 'package:im/pages/menu_container.dart';

class AppRouter {
  static const String initRoute = login;

  static const String login = "/login";
  static const String menuContainer = "/menuContainer";
  static const String chat = "/chat";
  static const String addFriend = "/addFriend";


  static List<GetPage> routes() {
    return [
      GetPage(name: login, page: () => const LoginPage()),
      GetPage(name: menuContainer, page: () => const MenuContainerPage()),
      GetPage(name: chat, page: () => ChatPage()),
      GetPage(name: addFriend, page: () => const AddFriendPage()),
    ];
  }

  static onUnknownRoute() {}
}
