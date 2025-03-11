import 'package:flutter/material.dart';
import 'package:silivri_havuz/controller/app_theme.dart';
import '/customWidgets/screen_background.dart';
import '../../view_model/home.dart';
import '../controller/app_state.dart';
import '../controller/provider.dart';
import '../customWidgets/theme_switch_button.dart';

class PageHome extends StatelessWidget {
  const PageHome({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = ViewModelHome.instance;

    return ScreenBackground(
      child: Provider<ViewModelHome>(
        model: vm,
        child: const Scaffold(
            backgroundColor: Colors.transparent,
            body: Row(children: [
              HomeSidebar(),
              // Main Content
              Expanded(child: HomeBody())
            ])),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final vm = Provider.of<ViewModelHome>(context);
    return Padding(
        padding: AppTheme.homeEdgeInsets,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Ink(
            padding: const EdgeInsets.all(AppTheme.gapxsmall),
            color: appState.themeData.primaryColorLight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Hoş Geldiniz, [Yetkili Adı]!", style: appState.themeData.textTheme.headlineMedium), const ThemeSwitchButton()],
            ),
          ),
          SizedBox(height: AppTheme.gapxxsmall),
          // Grid Content
          Expanded(child: IndexedStack(index: vm.screenIndex, children: List.from(vm.screenList.map((e) => e.body))))
        ]));
  }
}

class HomeSidebar extends StatelessWidget {
  const HomeSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final vm = Provider.of<ViewModelHome>(context);
    return Ink(
        width: MediaQuery.of(context).size.width * 0.2, // %20 genişlik
        color: appState.themeData.primaryColorLight,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Image.asset("assets/images/silivri-belediyesi-logo.png", fit: BoxFit.contain)),
            SizedBox(height: 16),
            Expanded(
                child: Column(
              children: [
                Text("Yönetici Paneli", textAlign: TextAlign.center, style: appState.themeData.textTheme.headlineMedium),
                SizedBox(height: 32),
                Expanded(
                    child: ListView.builder(
                        itemCount: vm.screenList.length,
                        itemBuilder: (context, index) => _buildSidebarItem(
                            vm.screenList.elementAt(index).icon, vm.screenList.elementAt(index).title, () => vm.setScreenIndex = index)))
              ],
            )),
            SizedBox(height: 16),
            Expanded(child: Image.asset("assets/images/silivri-slogan.png", fit: BoxFit.contain))
          ],
        ));
  }

  Widget _buildSidebarItem(IconData icon, String title, void Function()? onTap) {
    return InkWell(
        onTap: onTap,
        child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(),
            child: Row(children: [
              const SizedBox(width: 8),
              Icon(icon, color: AppState.instance.themeData.iconTheme.color),
              const SizedBox(width: 8),
              Text(title, style: AppState.instance.themeData.textTheme.headlineSmall),
              const SizedBox(width: 8)
            ])));
  }
}
