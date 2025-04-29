import 'package:flutter/material.dart';
import 'package:silivri_havuz/model/member_model.dart';

import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';
import '../../controller/provider.dart';
import '../../customWidgets/buttons/custom_button.dart';
import '../../customWidgets/cards/list_Item_member.dart';
import '../../customWidgets/search_and_filter.dart';
import '../../navigator/custom_navigation_view.dart';
import '../../navigator/ui_page.dart';
import '../../network/api.dart';
import '../../view_model/home.dart';
import '../../view_model/member_details.dart';
import 'member_launcher.dart';

class PageMembers extends StatelessWidget {
  const PageMembers({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final vm = Provider.of<ViewModelHome>(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: appState.themeData.primaryColorLight,
          scrolledUnderElevation: 0,
          leading: IconButton(onPressed: () => vm.resetAndFetchMemberModel(), icon: const Icon(Icons.refresh)),
          title: Text("Üye Yönetimi", style: appState.themeData.textTheme.headlineMedium),
          centerTitle: true,
          actions: [
            CustomButton(
                text: "Üye Ekle",
                onTap: () {
                  CustomRouter.instance.pushWidget(child: PageMemberLauncher(), pageConfig: ConfigMemberCreate);
                })
          ],
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: AppTheme.gapsmall),
          SearchAndFilter(controller: vm.memberSearchTextEditingController, onTap: () => vm.resetAndFetchMemberModel(search: vm.memberSearchTextEditingController.text)),

          const SizedBox(height: AppTheme.gapsmall),

          // Members List
          Expanded(
              child: StreamBuilder<List<MemberModel>>(
                  stream: vm.members.stream,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      return ListView.builder(
                          controller: vm.memberScrollController,
                          itemCount: asyncSnapshot.data!.length ?? 0, // Example data

                          itemBuilder: (context, index) {
                            return ListItemMember(
                                memberName: asyncSnapshot.data!.elementAt(index).displayName,
                                checkPayment: asyncSnapshot.data!.elementAt(index).paymentStatus!,
                                checkHealthy: asyncSnapshot.data!.elementAt(index).healthStatus!,
                                onTap: () {
                                  CustomRouter.instance.pushWidget(
                                      child: PageMemberLauncher(
                                        model: ViewModelMemberDetails.fromModel(memberModel: asyncSnapshot.data!.elementAt(index)),
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
        ]));
  }
}
