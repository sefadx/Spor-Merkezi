import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silivri_havuz/pages/login.dart';

import '../controller/app_state.dart';
import '../navigator/ui_page.dart';
import '../pages/home.dart';
import 'custom_page_route_builder.dart';

class PageAction {
  PageAction({
    this.state = PageState.none,
    this.page,
    this.pages,
    this.widget,
  });

  PageState state;
  PageConfiguration? page;
  List<PageConfiguration>? pages;
  Widget? widget;
}

enum PageState {
  none,
  addPage,
  addAll,
  addWidget,
  pop,
  replace,
  replacePush,
  replaceAll,
}

enum TransitionCustom {
  none,
  defaultTransition,
}

class CustomRouter extends RouterDelegate<PageConfiguration> with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfiguration> {
  CustomRouter._instance() : navigatorKey = GlobalKey<NavigatorState>() {
    _appState.addListener(() => notifyListeners());
  }

  final AppState _appState = AppState.instance;

  static CustomRouter get instance => _start;
  static final CustomRouter _start = CustomRouter._instance();

  final List<CustomPageRouteBuilder> _pages = [];
  List<CustomPageRouteBuilder> get pages => List<CustomPageRouteBuilder>.unmodifiable(_pages);

  @override
  PageConfiguration? get currentConfiguration => _pages.last.arguments as PageConfiguration?;

  @override
  //GlobalKey<NavigatorState>? get navigatorKey => throw UnimplementedError();
  final GlobalKey<NavigatorState>? navigatorKey;

  late Completer<bool> _resultData;

  /*Future<bool> waitForResult(PageAction action) async {
    _resultData = Completer<bool>();

    notifyListeners();
    return _resultData.future;
  }*/

  Future<bool> waitForResult(Widget child, PageConfiguration pageConfig) async {
    _resultData = Completer<bool>();
    _addPageData(child, pageConfig);
    return _resultData.future;
  }

  void returnWith(bool value) {
    pop();
    _resultData.complete(value);
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    final shouldAddPage = _pages.isEmpty || (_pages.last.arguments as PageConfiguration?)?.uiPage != configuration.uiPage;
    if (shouldAddPage) {
      _pages.clear();
      addPage(pageConfig: configuration);
    }
    return SynchronousFuture(null);
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      pop();
      notifyListeners();
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  bool _onPopPage(Route<dynamic> route, result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    if (canPop()) {
      pop();
      return true;
    } else {
      return false;
    }
  }

//------------------------------------------------------------------------------
//  Base Methods
//------------------------------------------------------------------------------
  bool canPop() {
    return _pages.length > 1;
  }

  void _removePage(Page page) {
    _pages.remove(page);
  }

  void _addPageData(Widget child, PageConfiguration pageConfig) {
    _pages.add(_createPage(child, pageConfig));
    notifyListeners();
  }

  CustomPageRouteBuilder _createPage(Widget child, PageConfiguration pageConfig) {
    return CustomPageRouteBuilder(pageRouteSettings: pageConfig.pageRouteSettings, child: child, key: Key(pageConfig.key) as LocalKey);
  }
//------------------------------------------------------------------------------
//  Base Methods
//------------------------------------------------------------------------------

  void pop() {
    if (canPop()) {
      _removePage(_pages.last);
      notifyListeners();
    }
  }

  void push(PageConfiguration pageConfig) {
    addPage(pageConfig: pageConfig);
  }

  void pushWidget({required Widget child, required PageConfiguration pageConfig}) {
    _addPageData(child, pageConfig);
    //notifyListeners();
  }

  void replace(PageConfiguration pageConfig) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    addPage(pageConfig: pageConfig);
  }

  void replacePushWidget({required Widget child, required PageConfiguration pageConfig}) {
    pop();
    _addPageData(child, pageConfig);
    notifyListeners();
  }

  void replaceAll(PageConfiguration pageConfig) {
    setNewRoutePath(pageConfig);
  }

  void addAll(List<PageConfiguration> routes) {
    _pages.clear();
    for (var route in routes) {
      addPage(pageConfig: route);
    }
  }

  void setPath(List<CustomPageRouteBuilder> path) {
    _pages.clear();
    _pages.addAll(path);
  }

  void addPage({required PageConfiguration pageConfig}) {
    final shouldPage = _pages.isEmpty || (_pages.last.arguments as PageConfiguration?)?.uiPage != pageConfig.uiPage;

    if (shouldPage) {
      switch (pageConfig.uiPage) {
        case Pages.Home:
          _addPageData(
            const PageHome(),
            pageConfig,
          );
          break;
        case Pages.Login:
          _addPageData(
            PageLogin(),
            pageConfig,
          );
          break;
        default:
          break;
      }
    }
    notifyListeners();
  }

  void _setPageAction(PageAction action) {
    switch (action.page!.uiPage) {
      case Pages.Home:
        ConfigHome.currentPageAction = action;
        break;
      default:
        break;
    }
  }

  List<Page> buildPages() {
    if (false
        //splashFinished
        ) {
    } else {
      switch (PageState.addAll) {
        case PageState.none:
          break;
        case PageState.addPage:
          _setPageAction(_appState.currentAction);
          addPage(pageConfig: _appState.currentAction.page!);
          break;
        case PageState.addAll:
          // TODO: Handle this case.
          break;
        case PageState.addWidget:
          // TODO: Handle this case.
          break;
        case PageState.pop:
          // TODO: Handle this case.
          break;
        case PageState.replace:
          // TODO: Handle this case.
          break;
        case PageState.replacePush:
          // TODO: Handle this case.
          break;
        case PageState.replaceAll:
          // TODO: Handle this case.
          break;
      }
    }
    _appState.resetCurrentAction();
    return List.of(_pages);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: buildPages(),
      onPopPage: _onPopPage,
    );
    throw UnimplementedError();
  }
}
