import 'package:flutter/material.dart';

import 'custom_navigation_view.dart';

class CustomBackButtonDispatcher extends RootBackButtonDispatcher {
  final CustomRouter _router;

  CustomBackButtonDispatcher(this._router) : super();

  @override
  Future<bool> didPopRoute() {
    return _router.popRoute();
  }
}
