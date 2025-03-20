import 'package:flutter/material.dart';
import 'package:silivri_havuz/customWidgets/buttons/custom_button.dart';

import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';
import '../../controller/provider.dart';
import '../../view_model/member_details.dart';
import 'member_form_content.dart';

class PageMemberLauncher extends StatelessWidget {
  PageMemberLauncher({ViewModelMemberDetails? model, super.key}) {
    vm = model ?? ViewModelMemberDetails();
  }

  late final ViewModelMemberDetails vm;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Provider(
      model: vm,
      child: Scaffold(
          backgroundColor: appState.themeData.scaffoldBackgroundColor,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Text('Üye Ekle', style: appState.themeData.textTheme.headlineLarge),
            actions: [
              CustomButton(
                  readOnly: vm.readOnly,
                  text: vm.readOnly ? "Güncelle" : "Kaydet",
                  margin: const EdgeInsets.only(right: AppTheme.gapsmall),
                  onTap: () => vm.onSave())
            ],
          ),
          body: const FormContentMember()),
    );
  }
}
