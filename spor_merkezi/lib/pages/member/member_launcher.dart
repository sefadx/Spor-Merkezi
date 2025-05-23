import 'package:flutter/material.dart';
import '../../customWidgets/buttons/custom_button.dart';
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
            backgroundColor: appState.themeData.scaffoldBackgroundColor,
            scrolledUnderElevation: 0,
            title: Text(vm.readOnly ? "Üye Bilgileri" : "Üye Ekle", style: appState.themeData.textTheme.headlineLarge),
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
