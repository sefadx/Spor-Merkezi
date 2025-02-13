import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:silivri_havuz/controller/app_theme.dart';

import 'controller/app_state.dart';
import 'navigator/back_dispatcher.dart';
import 'navigator/custom_navigation_view.dart';
import 'navigator/ui_page.dart';

void main() async {
  await GetStorage.init();
  runApp(const SporTesisi());
}

class SporTesisi extends StatefulWidget {
  const SporTesisi({super.key});

  @override
  State<SporTesisi> createState() => _SporTesisiState();
}

class _SporTesisiState extends State<SporTesisi> {
  late AppState appState;
  late CustomRouter router;
  late CustomBackButtonDispatcher backButtonDispatcher;

  _SporTesisiState() {
    appState = AppState.instance;
    //Dinamik tema değişimi için AppState sınıfı dinlemeyi başlat
    appState.addListener(() {
      setState(() {});
    });
    router = CustomRouter.instance;
    backButtonDispatcher = CustomBackButtonDispatcher(router);

    //router.setNewRoutePath(PageCustomerServicesMainConfig);
    router.setNewRoutePath(ConfigLogin);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      backButtonDispatcher: backButtonDispatcher,
      routerDelegate: router,
      theme: appState.themeData,
      //theme: AppTheme.lightTheme,
      //themeMode: ThemeMode.system,
      //darkTheme: AppTheme.darkTheme,
    );
  }
}
