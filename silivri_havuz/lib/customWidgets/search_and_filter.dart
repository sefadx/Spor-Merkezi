import 'package:flutter/material.dart';

import '../controller/app_state.dart';
import '../controller/provider.dart';
import 'buttons/custom_button.dart';
import 'custom_textfield.dart';

class SearchAndFilter extends StatelessWidget {
  SearchAndFilter({this.controller, this.onTap, super.key});

  void Function()? onTap;
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            prefixIcon: Icon(
              Icons.search,
              color: appState.themeData.iconTheme.color,
            ),
            controller: controller,
          ),
        ),
        SizedBox(width: 16),
        CustomButton(
          onTap: onTap,
          text: "Filtrele",
        ),
        /*ElevatedButton(
          onPressed: () {
            // Filter action
          },
          child: Text("Filtrele"),
        ),*/
      ],
    );
  }
}
