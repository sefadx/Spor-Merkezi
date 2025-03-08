import 'package:flutter/material.dart';
import '../../controller/app_state.dart';
import '../../customWidgets/screen_background.dart';
import '../../view_model/member_details.dart';
import 'member_form_content.dart';

class PageMemberCreate extends StatefulWidget {
  const PageMemberCreate({super.key});

  @override
  State<PageMemberCreate> createState() => _PageMemberCreateState();
}

class _PageMemberCreateState extends State<PageMemberCreate> {
  ViewModelMemberDetails vm = ViewModelMemberDetails();

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: Scaffold(
            appBar: AppBar(title: Text('Üye Ekle', style: AppState.instance.themeData.textTheme.headlineLarge)),
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: FormContentMember(
                    vm: vm,
                    onSaveText: "Kaydet",
                    onSave: () async {
                      await vm.onSave();
                      debugPrint("---------------------------Kaydet buton çalıştı ------------------------------");
                      //CustomRouter.instance.pop();
                    }))));
  }
}
