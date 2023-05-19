import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im/util/http_helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:im/router/app_router.dart';

void main() {
  runApp(const RootApplication());
}

class RootApplication extends StatelessWidget {
  const RootApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRouter.initRoute,
      getPages: AppRouter.routes(),
      builder: (context, child) => Scaffold(
        body: FlutterEasyLoading(
          // Global GestureDetector that will dismiss the keyboard
          child: GestureDetector(
            onTap: () {
              hideKeyboard(context);
            },
            child: child,
          ),
        ),
      ),
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }
}
