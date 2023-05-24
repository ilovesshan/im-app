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

  /// 初始化 SharedPreferences工具类
  await SpUtil.initSharedPreferences();
}

class RootApplication extends StatefulWidget {
  const RootApplication({Key? key}) : super(key: key);
  @override
  State<RootApplication> createState() => _RootApplicationState();
}

class _RootApplicationState extends State<RootApplication> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      printLog(StackTrace.current, "AppLifecycleState resumed");
    } else if (state == AppLifecycleState.inactive) {
      printLog(StackTrace.current, "AppLifecycleState inactive");
    } else if (state == AppLifecycleState.paused) {
      printLog(StackTrace.current, "AppLifecycleState paused");
    } else if (state == AppLifecycleState.detached) {
      printLog(StackTrace.current, "AppLifecycleState detached");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ImBindings(),
      initialRoute: AppRouter.initRoute,
      getPages: AppRouter.routes(),
      builder: (context, child) {
        /// 申请APP运行时相关权限
        PermissionUtil.requestAllPermission();
        /// android状态栏为透明沉浸式
        AppInitialize.setSystemUiOverlayStyle();
        /// UI适配
        AppInitialize.initScreenUtil(context);

        return Scaffold(
          body: GestureDetector(
            /// 点击空白区域关闭键盘
            onTap: () => AppInitialize.closeKeyBord(context),
            child: child,
          ),
        );
      },
    );
  }

  @override
  void deactivate() {
    super.deactivate();

    /// 移除对APP生命周期的监听
    WidgetsBinding.instance!.removeObserver(this);
  }
}

class ImBindings extends Bindings {
  @override
  void dependencies() {}
}
