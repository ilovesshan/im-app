import 'package:flutter/material.dart';

import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/router/app_router.dart';
import 'controller/chat_controller.dart';
import 'controller/message_controller.dart';
import 'controller/socket_controller.dart';

void main() async {
  runApp(const RootApplication());

  Get.put(ChatController(), permanent: true);
  Get.put(MessageController(), permanent: true);
  Get.put(SocketController(), permanent: true);

  await SpUtil.initSharedPreferences();
}

class RootApplication extends StatefulWidget {
  const RootApplication({Key? key}) : super(key: key);

  @override
  State<RootApplication> createState() => _RootApplicationState();
}

class _RootApplicationState extends State<RootApplication> with WidgetsBindingObserver {
  // SocketController _socketController = Get.put(SocketController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    PermissionUtils.requestAllPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      print("应用对用户可见并且可以响应用户的输入。这个事件对应于 Android 中的 `onPostResume()`；。");
    } else if (state == AppLifecycleState.inactive) {
      print("应用处于非活跃状态并且不接收用户输入。");
    } else if (state == AppLifecycleState.paused) {
      print("应用当前对用户不可见，无法响应用户输入，并运行在后台。这个事件对应于 Android 中的 `onPause()`；");
    } else if (state == AppLifecycleState.detached) {
     final String? userId =  await SpUtil.getValue("userId");
      // _socketController.logout(int.parse(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ImBindings(),
      initialRoute: AppRouter.initRoute,
      getPages: AppRouter.routes(),
      builder: (context, child) {
        // android状态栏为透明沉浸式
        AppInitialize.setSystemUiOverlayStyle();
        // 屏幕适配
        AppInitialize.initScreenUtil(context);
        return Scaffold(
          body: FlutterEasyLoading(
            // Global GestureDetector that will dismiss the keyboard
            child: GestureDetector(
              onTap: () {
                hideKeyboard(context);
              },
              child: child,
            ),
          ));
        },
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    // 注意deactivate时 请移除监听
    WidgetsBinding.instance!.removeObserver(this);
  }
}

class ImBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
    // Get.lazyPut<MessageController>(() => MessageController(), fenix: true);
    // Get.lazyPut<SocketController>(() => SocketController(), fenix: true);
  }
}
