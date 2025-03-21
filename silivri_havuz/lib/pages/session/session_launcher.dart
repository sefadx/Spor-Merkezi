import 'package:flutter/material.dart';

import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';
import '../../controller/provider.dart';
import '../../customWidgets/buttons/custom_button.dart';
import '../../pages/session/session_form_content.dart';
import '../../view_model/session_details.dart';

class PageSessionLauncher extends StatelessWidget {
  PageSessionLauncher({ViewModelSessionDetails? model, super.key}) {
    vm = model ?? ViewModelSessionDetails();
  }

  late final ViewModelSessionDetails vm;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Provider(
      model: vm,
      child: Scaffold(
        backgroundColor: appState.themeData.scaffoldBackgroundColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text('Seans Yönetimi', style: appState.themeData.textTheme.headlineLarge),
          actions: [
            CustomButton(
                readOnly: vm.readOnly,
                text: vm.readOnly ? "Seansı Güncelle" : "Seansı Oluştur",
                margin: const EdgeInsets.only(right: AppTheme.gapsmall),
                onTap: () => vm.onSave())
          ],
        ),
        body: const FormContentSession(),
      ),
    );
  }
}
