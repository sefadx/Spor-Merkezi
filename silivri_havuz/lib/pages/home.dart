import 'package:flutter/material.dart';
import '../view_model/home.dart';
import '/controller/app_state.dart';
import '/customWidgets/screen_background.dart';
import '/pages/reports/incomeReports.dart';
import '/pages/session/sessions.dart';
import 'package:get_storage/get_storage.dart';
import 'member/members.dart';

class PageHome extends StatefulWidget {
  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  ViewModelHome vm = ViewModelHome.instance;

  @override
  void initState() {
    vm.screenIndex.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Row(
          children: [
            // Sidebar
            Ink(
              width: MediaQuery.of(context).size.width * 0.2, // %20 genişlik
              color: AppState.instance.themeData.primaryColorLight,
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*Icon(
                    Icons.pool,
                    color: AppState.instance.themeData.iconTheme.color,
                    size: 80,
                  ),*/
                  Expanded(
                    child: Image.asset(
                      "assets/images/silivri-belediyesi-logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Yönetici Paneli",
                          textAlign: TextAlign.center,
                          style: AppState.instance.themeData.textTheme.headlineMedium,
                        ),
                        SizedBox(height: 32),
                        Expanded(
                          child: ListView.builder(
                              itemCount: vm.screenList.length,
                              itemBuilder: (context, index) {
                                return _buildSidebarItem(
                                  vm.screenList.elementAt(index).icon,
                                  vm.screenList.elementAt(index).title,
                                  () {
                                    vm.setScreenIndex = index;
                                  },
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Image.asset(
                      "assets/images/silivri-slogan.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      "Hoş Geldiniz, [Yetkili Adı]!",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),

                    // Grid Content
                    Expanded(
                        child: IndexedStack(
                      index: vm.getScreenIndex,
                      children: List.from(vm.screenList.map((e) => e.body)),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Icon(icon, color: AppState.instance.themeData.iconTheme.color),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppState.instance.themeData.textTheme.headlineSmall,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
