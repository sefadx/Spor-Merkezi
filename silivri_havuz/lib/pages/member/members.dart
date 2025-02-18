import 'package:flutter/material.dart';
import 'package:silivri_havuz/navigator/custom_navigation_view.dart';
import 'package:silivri_havuz/navigator/ui_page.dart';
import 'package:silivri_havuz/pages/member/member_details.dart';
import 'package:silivri_havuz/pages/session/sessions.dart';

import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';
import '../../customWidgets/buttons/custom_button.dart';
import '../../customWidgets/cards/list_Item_member.dart';
import '../../customWidgets/custom_textfield.dart';
import '../../customWidgets/search_and_filter.dart';
import '../../view_model/home.dart';
import '../../view_model/member_details.dart';
import 'member_create.dart';

class PageMembers extends StatefulWidget {
  const PageMembers({super.key});

  @override
  State<PageMembers> createState() => _PageMembersState();
}

class _PageMembersState extends State<PageMembers> {
  ViewModelHome vm = ViewModelHome.instance;

  @override
  void initState() {
    vm.members.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    vm.members.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(scrolledUnderElevation: 0, title: Text("Üye Yönetimi", style: AppState.instance.themeData.textTheme.headlineLarge), actions: [
          CustomButton(
              text: "Üye Ekle",
              onTap: () {
                CustomRouter.instance.pushWidget(child: PageMemberCreate(), pageConfig: ConfigMemberCreate);
              })
        ]),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SearchAndFilter(
                  controller: vm.memberSearchTextEditingController,
                  onTap: () {
                    vm.fetchMember(search: vm.memberSearchTextEditingController.text);
                  }),

              SizedBox(height: 16),

              // Members List
              Expanded(
                  child: ListView.builder(
                      itemCount: vm.members.value.length, // Example data

                      itemBuilder: (context, index) {
                        return ListItemMember(
                            memberName: vm.members.value.elementAt(index).displayName,
                            checkPayment: vm.members.value.elementAt(index).paymentStatus!,
                            checkHealthy: vm.members.value.elementAt(index).healthStatusCheck!,
                            onTap: () {
                              CustomRouter.instance.pushWidget(
                                  child: PageMemberDetails(
                                    vm: ViewModelMemberDetails.fromModel(model: vm.members.value.elementAt(index)),
                                  ),
                                  pageConfig: ConfigMemberDetails);
                            });
                      }))
            ])));
  }
}
