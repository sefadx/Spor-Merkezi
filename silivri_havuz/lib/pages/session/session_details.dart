import 'package:flutter/material.dart';
import '../../pages/session/session_form_content.dart';
import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';
import '../../customWidgets/buttons/custom_button.dart';
import '../../view_model/session_details.dart';

class PageSessionDetails extends StatelessWidget {
  const PageSessionDetails({required this.vm, super.key});

  final ViewModelSessionDetails vm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seans Yönetimi', style: AppState.instance.themeData.textTheme.headlineLarge),
        actions: [
          CustomButton(
            text: "Seansı Kaydet",
            margin: const EdgeInsets.only(right: AppTheme.gapsmall),
            onTap: () {
              vm.save();
            },
          ),
        ],
      ),
      body: FormContentSession(vm: vm),
    );
  }
}
