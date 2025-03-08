import 'package:flutter/material.dart';
import '../../controller/provider.dart';
import '../../navigator/custom_navigation_view.dart';
import '../../navigator/ui_page.dart';
import '../../pages/member/member_details.dart';

import '../../controller/app_state.dart';
import '../../customWidgets/buttons/custom_button.dart';
import '../../customWidgets/cards/list_Item_member.dart';
import '../../customWidgets/search_and_filter.dart';
import '../../network/api.dart';
import '../../view_model/home.dart';
import '../../view_model/member_details.dart';
import 'member_create.dart';

class PageMembers extends StatelessWidget {
  PageMembers({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final vm = Provider.of<ViewModelHome>(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: appState.themeData.primaryColorLight,
          scrolledUnderElevation: 0,
          title: Text("Üye Yönetimi", style: appState.themeData.textTheme.headlineLarge),
          actions: [
            CustomButton(
                text: "Üye Ekle",
                onTap: () {
                  CustomRouter.instance.pushWidget(child: PageMemberCreate(), pageConfig: ConfigMemberCreate);
                })
          ],
        ),
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
                  child: StreamBuilder(
                      stream: vm.members.stream,
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          return ListView.builder(
                              itemCount: asyncSnapshot.data!.length ?? 0, // Example data

                              itemBuilder: (context, index) {
                                return ListItemMember(
                                    memberName: asyncSnapshot.data!.elementAt(index).displayName,
                                    checkPayment: asyncSnapshot.data!.elementAt(index).paymentStatus!,
                                    checkHealthy: asyncSnapshot.data!.elementAt(index).healthStatus!,
                                    onTap: () {
                                      CustomRouter.instance.pushWidget(
                                          child: PageMemberDetails(
                                            vm: ViewModelMemberDetails.fromModel(model: asyncSnapshot.data!.elementAt(index)),
                                          ),
                                          pageConfig: ConfigMemberDetails);
                                    });
                              });
                        } else if (asyncSnapshot.hasError) {
                          return Center(child: Text((asyncSnapshot.error as BaseResponseModel).message.toString()));
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      })),
              /*Expanded(
                  child: FutureBuilder(
                      future: vm.fetchMember(),
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          return ListView.builder(
                              itemCount: vm.members.value.length ?? 0, // Example data

                              itemBuilder: (context, index) {
                                return ListItemMember(
                                    memberName: vm.members.value.elementAt(index).displayName,
                                    checkPayment: vm.members.value.elementAt(index).paymentStatus!,
                                    checkHealthy: vm.members.value.elementAt(index).healthStatus!,
                                    onTap: () {
                                      CustomRouter.instance.pushWidget(
                                          child: PageMemberDetails(
                                            vm: ViewModelMemberDetails.fromModel(model: vm.members.value.elementAt(index)),
                                          ),
                                          pageConfig: ConfigMemberDetails);
                                    });
                              });
                        } else if (asyncSnapshot.hasError) {
                          return Center(child: Text((asyncSnapshot.error as BaseResponseModel).message.toString()));
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      })),*/
            ])));
  }
}
