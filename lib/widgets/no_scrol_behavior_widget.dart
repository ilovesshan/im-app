import 'package:flutter/material.dart';

/// 去除listview水印
/// ScrollConfiguration behavior
class NoScrollBehaviorWidget extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child,
      AxisDirection axisDirection) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return child;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          axisDirection: axisDirection,
          color: Theme.of(context).accentColor,
          child: child,
          showTrailing: false,
          showLeading: false,);
      case TargetPlatform.linux:
        break;
      case TargetPlatform.macOS:
        break;
      case TargetPlatform.windows:
        break;
    }
    return child;
  }
}
