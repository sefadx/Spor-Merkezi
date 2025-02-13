import 'package:flutter/material.dart';

import '../controller/app_state.dart';

class CustomDropdownList extends StatelessWidget {
  CustomDropdownList({
    required this.list,
    this.onChanged,
    this.value,
    this.labelText,
    this.errorText,
    this.readOnly = false,
    super.key,
  });

  final String? labelText, errorText;
  final List<String> list;
  final void Function(String?)? onChanged;
  final String? value;
  final bool readOnly;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        ignoring: readOnly,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(labelText ?? "", style: AppState.instance.themeData.textTheme.bodyLarge),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
              value: value,
              focusColor: Colors.transparent,
              decoration: InputDecoration(
                  fillColor: AppState.instance.themeData.primaryColorLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              dropdownColor: AppState.instance.themeData.primaryColorLight,
              items: list
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender, style: AppState.instance.themeData.textTheme.bodyLarge),
                      ))
                  .toList(),
              onChanged: onChanged,
              validator: validator ?? (value) => value == null ? errorText ?? " Seçim yapın." : null)
        ]));
  }
}
