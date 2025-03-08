import 'package:flutter/material.dart';

import '../navigator/custom_navigation_view.dart';
import 'app_theme.dart';

class AppState extends ChangeNotifier {
  ///InheritedNotifier olayını yap chatgpt.com
  static AppState get instance => _start;
  static final AppState _start = AppState._instance();
  AppState._instance();

  ColorMode _colorMode = ColorMode.dark;
  ColorMode get colorMode => _colorMode;
  set colorMode(ColorMode colorMode) {
    _colorMode = colorMode;
    notifyListeners();
  }

  void toggleColorMode() {
    colorMode = colorMode == ColorMode.dark ? ColorMode.light : ColorMode.dark;
    //colorMode == ColorMode.dark ? ColorMode.light : ColorMode.dark;
  }

  PageAction _currentAction = PageAction();
  PageAction get currentAction => _currentAction;

  set currentAction(PageAction action) {
    _currentAction = action;
    notifyListeners();
  }

  void resetCurrentAction() {
    _currentAction = PageAction();
  }

//Uygulama Tema Rengi Fonksiyonları
  ThemeData get themeData => _colorMode == ColorMode.light ? AppTheme.lightTheme : AppTheme.darkTheme;
}
