import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silivri_havuz/customWidgets/buttons/custom_button.dart';

import '../controller/app_state.dart';
import '../controller/app_theme.dart';
import '../controller/provider.dart';
import '../navigator/custom_navigation_view.dart';

class PagePopupWidget extends StatelessWidget {
  const PagePopupWidget({required this.widget, this.actionButton, this.onTapClose, super.key});

  final Widget widget;
  final Function()? onTapClose;
  final CustomButton? actionButton;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Material(
        color: Colors.transparent,
        child: Align(
            alignment: Alignment.center,
            child: Padding(
                padding: const EdgeInsets.all(AppTheme.gapxxlarge),
                child: Ink(
                    padding: const EdgeInsets.all(AppTheme.gapxxsmall),
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                        color: appState.themeData.primaryColorLight,
                        borderRadius: BorderRadius.circular(AppTheme.radiussmall),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 7)]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(onPressed: onTapClose ?? () => CustomRouter.instance.pop(), icon: const Icon(Icons.close)),
                            actionButton ?? const SizedBox()
                          ],
                        ),
                        widget,
                      ],
                    )))));
  }
}
