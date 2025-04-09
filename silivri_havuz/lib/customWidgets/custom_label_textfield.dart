import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/app_state.dart';
import '../controller/provider.dart';
import 'custom_textfield.dart';

class CustomLabelTextField extends StatelessWidget {
  const CustomLabelTextField({
    this.controller,
    this.label,
    this.hintText,
    this.validator,
    this.onTap,
    this.suffixIcon,
    this.readOnly = false,
    this.onChanged,
    this.inputFormatter,
    super.key,
  });

  final TextEditingController? controller;
  final String? label, hintText;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final Widget? suffixIcon;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatter;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label ?? "", style: appState.themeData.textTheme.bodyLarge),
        const SizedBox(height: 5),
        CustomTextField(
          inputFormatter: inputFormatter,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          controller: controller,
          validator: validator,
          suffixIcon: suffixIcon,
          hintText: hintText,
        )
      ],
    );
  }
}

class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), ''); // Sadece sayıları al
    String formattedText = '';

    for (int i = 0; i < text.length; i++) {
      if (i == 2 || i == 4) {
        formattedText += '/';
      }
      formattedText += text[i];
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
