import 'package:flutter/material.dart';

import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    this.decoration,
    this.onTap,
    super.key,
  });

  final String text;
  final void Function()? onTap;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Ink(
        decoration: decoration ?? AppTheme.buttonSecondaryDecoration,
        padding: const EdgeInsets.all(AppTheme.gapsmall),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppState.instance.themeData.textTheme.headlineSmall,
        ),
      ),
    );
  }
}
