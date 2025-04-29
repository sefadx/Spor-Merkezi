import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/app_state.dart';
import '../controller/app_theme.dart';
import '../controller/provider.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.passwordVisible = false,
    this.controller,
    this.validator,
    this.inputFormatter,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    super.key,
  });

  final String? hintText;
  final TextEditingController? controller;
  final Widget? prefixIcon, suffixIcon;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final bool readOnly, passwordVisible;
  final List<TextInputFormatter>? inputFormatter;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return TextFormField(
      obscureText: passwordVisible,
      textInputAction: TextInputAction.search,
      onFieldSubmitted: onFieldSubmitted,
      enabled: !readOnly,
      readOnly: readOnly,
      controller: controller,
      validator: validator,
      style: appState.themeData.textTheme.bodyMedium,
      onTap: onTap,
      onChanged: onChanged,
      inputFormatters: inputFormatter,
      cursorColor: AppTheme.blackWhiteReversed(context),
      decoration: InputDecoration(
        enabledBorder: appState.themeData.inputDecorationTheme.enabledBorder,
        disabledBorder: appState.themeData.inputDecorationTheme.disabledBorder,
        focusedBorder: appState.themeData.inputDecorationTheme.focusedBorder,
        hintText: hintText,
        hintStyle: appState.themeData.textTheme.bodyLarge,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
