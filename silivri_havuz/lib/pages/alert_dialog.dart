import 'package:flutter/material.dart';
import 'package:silivri_havuz/navigator/custom_navigation_view.dart';
import '../controller/app_state.dart';
import '../controller/app_theme.dart';
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

  //Alertdialog yazılacak  hayır a basınca false dönecek.

  final String title, informationText, acceptText, cancelText;
  final void Function()? onTapCancel, onTapAccept;

  @override
  Widget build(BuildContext context) {
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
                        color: AppState.instance.themeData.primaryColor,
                        borderRadius: BorderRadius.circular(AppTheme.radiussmall)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(title,
                            textAlign: TextAlign.center, style: AppState.instance.themeData.textTheme.headlineLarge),
                        const SizedBox(height: AppTheme.gapmedium),
                        Text(informationText,
                            textAlign: TextAlign.center, style: AppState.instance.themeData.textTheme.bodyLarge),
                        const SizedBox(height: AppTheme.gapmedium),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Expanded(
                              child: CustomButton(
                                  text: acceptText,
                                  onTap: () {
                                    CustomRouter.instance.returnWith(true);
                                  })),
                          const SizedBox(width: AppTheme.gapsmall),
                          Expanded(
                              child: CustomButton(
                                  text: cancelText,
                                  onTap: () {
                                    CustomRouter.instance.returnWith(false);
                                  }))
                        ])
                      ],
                    ))))); /*Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.teal,
            border: Border.all(
              width: 3,
              color: Colors.teal.shade700,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.white,
                  //fontFamily: DefaultTextStyle.of(context).style.fontFamily,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                informationText,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.white,
                  //fontFamily: DefaultTextStyle.of(context).style.fontFamily,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: leftButtonText,
                      onTap: onTapAccept,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomButton(
                      text: rightButtonText,
                      onTap: onTapCancel,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );*/
  }
}
