import 'package:flutter/material.dart';

import 'custom_navigation_view.dart';

class PageConfiguration {
  PageConfiguration(
      {required this.key, required this.path, this.uiPage, this.pageRouteSettings = PageRouteSettings.defaultSettings, this.currentPageAction});

  final String key;
  final String path;
  final Pages? uiPage;
  PageRouteSettings pageRouteSettings;
  PageAction? currentPageAction;
}

class PageRouteSettings {
  const PageRouteSettings({
    this.fullScreenDialog = true,
    this.backgroundOpaque = false,
    this.barrierDismissible = false,
    this.barrierColor,
  });

  static const defaultSettings = PageRouteSettings();

  final Color? barrierColor;
  final bool backgroundOpaque, barrierDismissible, fullScreenDialog;
}

enum Pages { Home, Login, MemberCreate, NemberDetails, SessionCreate, PopupInfo, AlertDialog, Widget }

//------------------------------------------------------------------------------
const String PathHome = '/pages/home';

PageConfiguration ConfigHome = PageConfiguration(key: 'Home', path: PathHome, uiPage: Pages.Home, currentPageAction: null);

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
const String PathLogin = '/pages/login';

PageConfiguration ConfigLogin = PageConfiguration(key: 'Login', path: PathLogin, uiPage: Pages.Login, currentPageAction: null);

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
const String PathMemberCreate = '/pages/member_create';

PageConfiguration ConfigMemberCreate =
    PageConfiguration(key: 'MemberCreate', path: PathMemberCreate, uiPage: Pages.MemberCreate, currentPageAction: null);

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
const String PathMemberDetails = '/pages/member_details';

PageConfiguration ConfigMemberDetails =
    PageConfiguration(key: 'MemberDetails', path: PathMemberDetails, uiPage: Pages.NemberDetails, currentPageAction: null);

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
const String PathSessionCreate = '/pages/session_create';

PageConfiguration ConfigSessionCreate =
    PageConfiguration(key: 'SessionCreate', path: PathSessionCreate, uiPage: Pages.SessionCreate, currentPageAction: null);

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
const String PathPopupInfo = '/pages/popup_info';

PageConfiguration ConfigPopupInfo() {
  final uniqueKey = UniqueKey().toString();

  return PageConfiguration(
      key: 'PopupInfo_$uniqueKey)',
      path: '$PathPopupInfo/$uniqueKey',
      uiPage: Pages.PopupInfo,
      pageRouteSettings: const PageRouteSettings(
        barrierDismissible: true,
        fullScreenDialog: false,
        backgroundOpaque: false,
      ),
      currentPageAction: null);
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
const String PathAlertDialog = '/pages/alert_dialog';

PageConfiguration ConfigAlertDialog = PageConfiguration(
    key: 'AlertDialog',
    path: PathAlertDialog,
    uiPage: Pages.AlertDialog,
    pageRouteSettings: const PageRouteSettings(
      barrierDismissible: true,
      fullScreenDialog: false,
      backgroundOpaque: false,
    ),
    currentPageAction: null);

//------------------------------------------------------------------------------
//-----------------Custom Widget------------------------------------------------
const String PageCustomWidgetPath = '/customWidgets/custom_widget';

PageConfiguration PageCustomWidgetConfig = PageConfiguration(
    key: 'CustomWidget',
    path: PageCustomWidgetPath,
    uiPage: Pages.Widget,
    pageRouteSettings: const PageRouteSettings(
      barrierDismissible: true,
      fullScreenDialog: false,
      backgroundOpaque: false,
    ),
    currentPageAction: null);

/*
const String PopupInfoPath = '/popupInfo';

PageConfiguration PopupInfoConfig = PageConfiguration(
    key: 'PopupInfo', path: PopupInfoPath, currentPageAction: null);

//------------------------------------------------------------------------------
*/
