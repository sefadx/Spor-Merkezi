import 'package:flutter/material.dart';
import '../../controller/app_state.dart';
import '../../navigator/custom_navigation_view.dart';
import '../../navigator/ui_page.dart';
import '../../pages/alert_dialog.dart';
import '../../pages/session/session_create.dart';
import '../../view_model/home.dart';

import '../../controller/app_theme.dart';
import '../../customWidgets/buttons/custom_button.dart';
import '../../customWidgets/cards/list_item_session.dart';
import '../../customWidgets/search_and_filter.dart';
import '../../model/session_model.dart';

class PageSessions extends StatefulWidget {
  @override
  State<PageSessions> createState() => _PageSessionsState();
}

class _PageSessionsState extends State<PageSessions> {
  ValueNotifier<List<SessionModel>> vmSessionList = ViewModelHome.instance.sessions;
  @override
  void initState() {
    vmSessionList.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    vmSessionList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text("Seans Yönetimi", style: AppState.instance.themeData.textTheme.headlineLarge),
          actions: [
            CustomButton(
                text: "Seans Ekle",
                onTap: () {
                  CustomRouter.instance.pushWidget(child: PageSessionCreate(), pageConfig: ConfigSessionCreate);
                })
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Search and Filter Section
              SearchAndFilter(
                onTap: () {},
              ),

              SizedBox(height: AppTheme.gapmedium),

              // Sessions List
              Expanded(
                  child: vmSessionList.value.isEmpty
                      ? const Center(
                          child: Text("Seans yok"),
                        )
                      : ListView.builder(
                          itemCount: vmSessionList.value.length, // Example data
                          itemBuilder: (context, index) {
                            return SessionCard(
                              sessionName: vmSessionList.value.elementAt(index).sessionName,
                              trainerName: vmSessionList.value.elementAt(index).trainer,
                              date: vmSessionList.value.elementAt(index).date,
                              time: "${vmSessionList.value.elementAt(index).timeStart}:${vmSessionList.value.elementAt(index).timeEnd}",
                              capacity: vmSessionList.value.elementAt(index).capacity.toString(),
                              onTapDetails: () {
                                // Navigate to participants list
                              },
                              onEdit: () {
                                // Navigate to edit session page
                              },
                              onDelete: () {
                                // Delete session
                              },
                            );
                          }))
            ])));
  }
}
