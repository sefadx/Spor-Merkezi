import 'package:flutter/material.dart';

import '../navigator/ui_page.dart';

class CustomPageRouteBuilder extends Page {
  const CustomPageRouteBuilder({
    required this.pageRouteSettings,
    required this.child,
    required LocalKey key,
  }) : super(key: key);

  final Widget child;
  final PageRouteSettings pageRouteSettings;
  //Widget Function(BuildContext, Animation<double>, Animation<double>) transition;
  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
        barrierColor: pageRouteSettings.barrierColor,
        opaque: pageRouteSettings.backgroundOpaque,
        barrierDismissible: pageRouteSettings.barrierDismissible,
        fullscreenDialog: pageRouteSettings.fullScreenDialog,
        settings: this,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return FadeTransition(opacity: animation, child: child);
        });
  }
}
