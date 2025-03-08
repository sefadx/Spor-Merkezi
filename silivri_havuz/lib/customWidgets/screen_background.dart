import 'package:flutter/material.dart';
import 'package:silivri_havuz/controller/app_state.dart';
import 'package:silivri_havuz/controller/app_theme.dart';

import '../controller/provider.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({
    required this.child,
    this.onBackroundTap,
    super.key,
  });

  final Widget child;
  final Function()? onBackroundTap;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onBackroundTap;
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: appState.colorMode == ColorMode.dark
                ? [AppTheme.accentColor, appState.themeData.primaryColorLight]
                : [Colors.white, AppTheme.accentColor],
          ),
        ),
        child: child,
      ),
    );
  }
}
