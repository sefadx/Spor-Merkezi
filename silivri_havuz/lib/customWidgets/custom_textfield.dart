import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/app_state.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.inputFormatter,
    this.onTap,
    this.readOnly = false,
    super.key,
  });

  final String? hintText;
  final TextEditingController? controller;
  final Widget? prefixIcon, suffixIcon;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatter;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      validator: validator,
      onTap: onTap,
      inputFormatters: inputFormatter,
      cursorColor: AppState.instance.themeData.primaryColorDark,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
