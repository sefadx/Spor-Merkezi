
import 'package:flutter/material.dart';

import '/customWidgets/buttons/custom_button.dart';
import '../controller/app_state.dart';
import '../controller/app_theme.dart';
import '../controller/provider.dart';
import '../navigator/custom_navigation_view.dart';

class PagePopupWidget extends StatelessWidget {
  const PagePopupWidget({this.title, required this.widget, this.actionButton, this.onTapClose, this.backgroundColor, super.key});

  final Widget widget;
  final Function()? onTapClose;
  final CustomButton? actionButton;
  final String? title;
  final Color? backgroundColor;

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
                        color: backgroundColor ?? appState.themeData.primaryColorLight,
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
                            Text(title ?? "", style: appState.themeData.textTheme.headlineMedium),
                            actionButton ??
                                const SizedBox(
                                  width: 15,
                                )
                          ],
                        ),
                        widget,
                      ],
                    )))));
  }
}
