import 'package:flutter/material.dart';

import '../controller/app_state.dart';
import '../controller/provider.dart';

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
    final appState = Provider.of<AppState>(context);
    return IgnorePointer(
        ignoring: readOnly,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(labelText ?? "", style: appState.themeData.textTheme.bodyLarge),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
              value: value,
              focusColor: Colors.transparent,
              decoration: InputDecoration(
                  enabled: !readOnly,
                  fillColor: appState.themeData.primaryColorLight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              dropdownColor: appState.themeData.primaryColorLight,
              items: list
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender, style: appState.themeData.textTheme.bodyLarge),
                      ))
                  .toList(),
              onChanged: onChanged,
              validator: validator ?? (value) => value == null ? errorText ?? " Seçim yapın." : null)
        ]));
  }
}
