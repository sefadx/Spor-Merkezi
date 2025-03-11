import 'package:flutter/material.dart';

import '../controller/app_state.dart';
import '../controller/provider.dart';
import 'buttons/custom_button.dart';
import 'custom_textfield.dart';

@immutable
class SearchAndFilter extends StatelessWidget {
  const SearchAndFilter({this.controller, this.onTap, this.hintText, super.key});

  final String? hintText;
  final void Function()? onTap;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Row(
      children: [
        Expanded(
            child: CustomTextField(
          hintText: hintText,
          prefixIcon: Icon(Icons.search, color: appState.themeData.iconTheme.color),
          controller: controller,
        )),
        SizedBox(width: 16),
        CustomButton(onTap: onTap, text: "Filtrele")
      ],
    );
  }
}
