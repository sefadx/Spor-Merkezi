import 'package:flutter/material.dart';

import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';
import '../../controller/provider.dart';
import '../../customWidgets/buttons/custom_button.dart';
import '../../customWidgets/cards/list_item_session.dart';
import '../../customWidgets/search_and_filter.dart';
import '../../model/session_model.dart';
import '../../navigator/custom_navigation_view.dart';
import '../../navigator/ui_page.dart';
import '../../network/api.dart';
import '../../pages/session/session_launcher.dart';
import '../../view_model/home.dart';
import '../../view_model/session_details.dart';

class PageSessions extends StatelessWidget {
  const PageSessions({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final vm = Provider.of<ViewModelHome>(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: appState.themeData.primaryColorLight,
          scrolledUnderElevation: 0,
          leading: IconButton(onPressed: () => vm.fetchSession(), icon: const Icon(Icons.refresh)),
          title: Text("Seans Yönetimi", style: appState.themeData.textTheme.headlineMedium),
          actions: [
            CustomButton(
                text: "Seans Ekle", onTap: () => CustomRouter.instance.pushWidget(child: PageSessionLauncher(), pageConfig: ConfigSessionCreate))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppTheme.gapsmall),
            // Search and Filter Section
            SearchAndFilter(onTap: () {}),

            SizedBox(height: AppTheme.gapsmall),

            // Sessions List
            Expanded(
                child: StreamBuilder<List<SessionModel>>(
                    stream: vm.sessions.stream,
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.hasData) {
                        return ListView.builder(
                            itemCount: asyncSnapshot.data?.length ?? 0, // Example data
                            itemBuilder: (context, index) {
                              return SessionCard(
                                sessionName: asyncSnapshot.data!.elementAt(index).sportType.toString(),
                                trainerName: asyncSnapshot.data!.elementAt(index).trainer.displayName,
                                date: asyncSnapshot.data!.elementAt(index).date,
                                time: "${asyncSnapshot.data!.elementAt(index).timeStart} - ${asyncSnapshot.data!.elementAt(index).timeEnd}",
                                capacity: asyncSnapshot.data!.elementAt(index).capacity.toString(),
                                onTapMembers: () {},
                                onTapDetails: () {
                                  CustomRouter.instance.pushWidget(
                                      child:
                                          PageSessionLauncher(model: ViewModelSessionDetails.fromModel(model: asyncSnapshot.data!.elementAt(index))),
                                      pageConfig: ConfigSessionCreate);
                                },
                              );
                            });
                      } else if (asyncSnapshot.hasError) {
                        return Center(child: Text((asyncSnapshot.error as BaseResponseModel).message.toString()));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    })),
          ],
        ));
  }
}
