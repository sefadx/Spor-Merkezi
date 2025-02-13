import 'package:flutter/material.dart';
import 'package:silivri_havuz/controller/app_state.dart';
import 'package:silivri_havuz/controller/app_theme.dart';

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
            colors: [
              AppTheme.accentColor,
              AppState.instance.themeData.primaryColorLight
              //Colors.blue, Colors.white,
              //Color(0xffA6D8D4),
              //Color(0xff037870),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}
