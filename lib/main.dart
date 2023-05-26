import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:common_utils_v2/common_utils_v2.dart';

import 'package:im/controller/chat_controller.dart';
import 'package:im/controller/friend_list_controller.dart';
import 'package:im/controller/message_controller.dart';
import 'package:im/controller/socket_controller.dart';

import 'package:im/router/app_router.dart';

void main() async {
  /// 覆盖HttpHelperUtil的默认BaseUrl地址
  HttpHelperUtil.updateBaseUrl(baseurl: "https://43967714.cpolar.io", baseWsUrl: "ws://7bb8c5be.cpolar.io/ws");

  /// 添加Flutter全局异常捕获
  runZonedGuarded(() => runApp(const RootApplication()), (Object error, StackTrace stack) {
    /// 没有被代码catch到的异常
    Log.e(error.toString(), error, stack);
  });

  /// 初始化 SharedPreferences(可选)
  await SpUtil.initSharedPreferences();

  /// 初始化 Sqlite数据库(可选)
  await initSqliteDb();
}

class RootApplication extends StatefulWidget {
  const RootApplication({Key? key}) : super(key: key);

  @override
  State<RootApplication> createState() => _RootApplicationState();
}

class _RootApplicationState extends State<RootApplication> {
  @override
  Widget build(BuildContext context) {
    /// 实现清明灰色主题 Colors.transparent(正常) Colors.grey(清明灰)
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(Colors.transparent, BlendMode.color),

      /// 使用 GetMaterialApp替换MaterialApp
      child: GetMaterialApp(
        /// APP主题配色方案
        theme: AppInitialize.appTheme("2196f3"),

        /// 使用Get提供的路由解决方案(也可自行选择其他三方库)
        initialRoute: AppRouter.initRoute,
        getPages: AppRouter.routes(),
        navigatorKey: Get.key,
        onUnknownRoute: (routeSettings) => AppRouter.onUnknownRoute(routeSettings),
        routingCallback: (routing) => AppRouter.routingCallback(routing!),
        navigatorObservers: [
          /// 如果未使用GetMaterialApp ,则可以通过navigatorObservers来观察路由变化
          GetObserver()
        ],

        /// 初始化时注入Bindings
        initialBinding: InitBinding(),

        /// Get控制器的管理机制,默认 SmartManagement.full
        smartManagement: SmartManagement.full,
        builder: (context, child) {
          /// android状态栏为透明沉浸式
          AppInitialize.setSystemUiOverlayStyle();

          /// 屏幕适配
          AppInitialize.initScreenUtil(context);
          return FlutterEasyLoading(
            child: GestureDetector(
              child: child!,

              /// 点击空白区域关闭键盘
              onTap: () => AppInitialize.closeKeyBord(context),
            ),
          );
        },
      ),
    );
  }
}

/// 初始化 Sqlite数据库（请适当对代码进行抽取）
Future<void> initSqliteDb() async {
  /// 初始化数据库
  await SqliteHelperUtil.openDb(
    dbName: "im",
    version: 1,
    onCreate: (db, version) {
      Log.d("数据库初始化：version = $version");
      db.execute("""""");
    },
    onUpgrade: (db, oldVersion, newVersion) {
      Log.d("数据库版本升级：oldVersion = $oldVersion, newVersion = $newVersion");
    },
    onDowngrade: (db, oldVersion, newVersion) {
      Log.d("数据库版本降低级：oldVersion = $oldVersion, newVersion = $newVersion");
    },
  );
}

/// 初始化bindings（请适当对代码进行抽取）
class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SocketController(), permanent: true);

    /// 如果为false 第二次进入时，再通过find时会报错，只能使用put进行注入(创建一个新的对象)
    /// 如果为true 第二次进入时，不会重新创建，导致数据还是之前旧的数据
    // Get.lazyPut(() => ChatController(), fenix: false);
    // Get.lazyPut(() => MessageController(), fenix: false);
    // Get.lazyPut(() => FriendListController(), fenix: false);
  }
}