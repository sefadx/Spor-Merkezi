import 'package:flutter/material.dart';
import '../navigator/custom_navigation_view.dart';

import '../controller/app_state.dart';
import '../controller/app_theme.dart';
import '../controller/provider.dart';
import '../customWidgets/buttons/custom_button.dart';

class PageAlertDialog extends StatelessWidget {
  const PageAlertDialog({
    required this.title,
    required this.informationText,
    this.acceptText = "Evet",
    this.cancelText = "Hayır",
    this.onTapAccept,
    this.onTapCancel,
    super.key,
  });

  final String title, informationText, acceptText, cancelText;
  final void Function()? onTapCancel, onTapAccept;

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
                    padding: const EdgeInsets.all(AppTheme.gapmedium),
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                        color: appState.themeData.primaryColor,
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
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Expanded(child: CustomButton(text: acceptText, onTap: () => CustomRouter.instance.returnWith(true))),
                          const SizedBox(width: AppTheme.gapsmall),
                          Expanded(child: CustomButton(text: cancelText, onTap: () => CustomRouter.instance.returnWith(false)))
                        ])
                      ],
                    )))));
  }
}
