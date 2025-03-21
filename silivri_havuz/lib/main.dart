import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'controller/app_state.dart';
import 'controller/provider.dart';
import 'navigator/back_dispatcher.dart';
import 'navigator/custom_navigation_view.dart';
import 'navigator/ui_page.dart';

void main() async {
  await GetStorage.init();
  runApp(SporTesisi());
}

class SporTesisi extends StatelessWidget {
  SporTesisi({super.key}) {
    router = CustomRouter.instance;
    backButtonDispatcher = CustomBackButtonDispatcher(router);
    router.setNewRoutePath(ConfigLogin);
  }

  late final CustomRouter router;
  late final CustomBackButtonDispatcher backButtonDispatcher;

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;
    initializeDateFormatting('tr');
    return Provider<AppState>(
      model: appState,
      child: MaterialApp.router(
        backButtonDispatcher: backButtonDispatcher,
        routerDelegate: router,
        theme: appState.themeData,
        debugShowCheckedModeBanner: false,
        //theme: AppTheme.lightTheme,
        //themeMode: ThemeMode.system,
        //darkTheme: AppTheme.darkTheme,
      ),
    );
  }
}
