import 'package:flutter/material.dart';
import 'package:silivri_havuz/controller/app_state.dart';
import 'package:silivri_havuz/navigator/custom_navigation_view.dart';
import 'package:silivri_havuz/navigator/ui_page.dart';
import 'package:silivri_havuz/pages/alert_dialog.dart';
import 'package:silivri_havuz/pages/session/session_create.dart';
import 'package:silivri_havuz/view_model/home.dart';

import '../../controller/app_theme.dart';
import '../../customWidgets/buttons/custom_button.dart';
import '../../customWidgets/cards/list_item_session.dart';
import '../../customWidgets/search_and_filter.dart';

class PageSessions extends StatefulWidget {
  @override
  State<PageSessions> createState() => _PageSessionsState();
}

class _PageSessionsState extends State<PageSessions> {
  @override
  void initState() {
    ViewModelHome.instance.sessions.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    ViewModelHome.instance.sessions.dispose();
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
                  child: ViewModelHome.instance.sessions.value.isEmpty
                      ? const Center(
                          child: Text("Seans yok"),
                        )
                      : ListView.builder(
                          itemCount: ViewModelHome.instance.sessions.value.length, // Example data
                          itemBuilder: (context, index) {
                            return SessionCard(
                              sessionName: ViewModelHome.instance.sessions.value.elementAt(index).sessionName,
                              trainerName: ViewModelHome.instance.sessions.value.elementAt(index).trainerName,
                              date: ViewModelHome.instance.sessions.value.elementAt(index).dateString,
                              time: "10.00 - 12.00",
                              capacity: ViewModelHome.instance.sessions.value.elementAt(index).capacity.toString(),
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
