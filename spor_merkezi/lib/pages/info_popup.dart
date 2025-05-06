import 'dart:async';

import 'package:flutter/material.dart';

import '../controller/app_state.dart';
import '../controller/app_theme.dart';
import '../controller/provider.dart';
import '../navigator/custom_navigation_view.dart';

class PagePopupInfo extends StatelessWidget {
  const PagePopupInfo({required this.title, required this.informationText, this.seconds = 2, this.afterDelay, super.key});

  final String title, informationText;
  final int seconds;
  final void Function()? afterDelay;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    Timer(
      Duration(seconds: seconds),
      afterDelay ?? () => CustomRouter.instance.pop(),
    );
    return Material(
        color: Colors.transparent,
        child: Align(
            alignment: Alignment.center,
            child: Padding(
                padding: const EdgeInsets.all(AppTheme.gapxxlarge),
                child: Ink(
                    padding: const EdgeInsets.all(AppTheme.gapmedium),
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                        color: appState.themeData.primaryColorLight,
                        borderRadius: BorderRadius.circular(AppTheme.radiussmall),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 7)]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(title, textAlign: TextAlign.center, style: appState.themeData.textTheme.headlineLarge),
                        const SizedBox(height: AppTheme.gapmedium),
                        Text(informationText, textAlign: TextAlign.center, style: appState.themeData.textTheme.bodyLarge),
                        const SizedBox(height: AppTheme.gapmedium),
                      ],
                    )))));
  }
}
