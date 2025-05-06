import 'package:flutter/material.dart';

import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';
import '../../controller/provider.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    this.margin,
    this.padding,
    this.decoration,
    this.onTap,
    this.readOnly = false,
    super.key,
  });

  final String text;
  final void Function()? onTap;
  final BoxDecoration? decoration;
  final EdgeInsets? padding, margin;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: readOnly ? null : onTap,
          child: Ink(
              decoration: decoration ?? AppTheme.buttonSecondaryDecoration(context),
              padding: padding ?? const EdgeInsets.all(AppTheme.gapsmall),
              child: Text(text, textAlign: TextAlign.center, style: AppState.instance.themeData.textTheme.headlineSmall))),
    );
  }
}
