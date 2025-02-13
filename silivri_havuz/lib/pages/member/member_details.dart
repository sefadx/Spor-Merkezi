import 'package:flutter/material.dart';
import "../../controller/app_state.dart";
import "../../customWidgets/screen_background.dart";
import "../../view_model/member_details.dart";
import 'member_form_content.dart';

class PageMemberDetails extends StatelessWidget {
  PageMemberDetails({required this.vm, super.key});

  final ViewModelMemberDetails vm;

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: Scaffold(
            appBar: AppBar(title: Text('Üye Detayları', style: AppState.instance.themeData.textTheme.headlineLarge)),
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: FormContent(
                  vm: vm,
                  onSaveText: "Kaydet",
                  onSave: () async {
                    await vm.onSave();
                  },
                ))));
  }
}
