import 'package:flutter/material.dart';
import '../../utils/enums.dart';
import '../info_popup.dart';
import '/customWidgets/cards/list_item_week.dart';
import '/utils/extension.dart';
import '/view_model/table.dart';
import '/model/table_model.dart';
import '/controller/app_state.dart';
import '/controller/app_theme.dart';
import '/controller/provider.dart';
import '/customWidgets/buttons/custom_button.dart';
import '/navigator/custom_navigation_view.dart';
import '/navigator/ui_page.dart';
import '/network/api.dart';
import '/view_model/home.dart';
import '../table.dart';

class PageSessions extends StatelessWidget {
  PageSessions({super.key});

  final WeekModel week = WeekModel(
      daysOff: [],
      initialDayOfWeek: DateTime(2020),
      days: [
        Day(name: "Pazartesi", day: 1, activities: [
          Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
          null,
          Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
          null,
          Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
          null,
          Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
          null,
          Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
          null,
          Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
          null,
          Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
          null,
          Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
          null,
          Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty)
        ]),
        Day(name: "Salı", day: 2, activities: [
          Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
          null,
          Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
          null,
          Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
          null,
          Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.free),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid)
        ]),
        Day(name: "Çarşamba", day: 3, activities: [
          Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
          null,
          Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
          null,
          Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
          null,
          Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.free),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid)
        ]),
        Day(name: "Perşembe", day: 4, activities: [
          Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
          null,
          Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
          null,
          Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
          null,
          Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.free),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid)
        ]),
        Day(name: "Cuma", day: 5, activities: [
          Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
          null,
          Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
          null,
          Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
          null,
          Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.free),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid)
        ]),
        Day(name: "Cumartesi", day: 6, activities: [
          Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.havuzBakim, ageGroup: AgeGroup.all, fee: FeeType.free)
        ]),
        Day(name: "Pazar", day: 7, activities: [
          Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
          null,
          Activity(type: ActivityType.havuzBakim, ageGroup: AgeGroup.all, fee: FeeType.free)
        ]),
      ]);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final vm = Provider.of<ViewModelHome>(context);
    void addWeekButton() async {
      DateTime now = DateTime.now();
      DateTime lastDay = DateTime.now().add(const Duration(days: 90));
      DateTime monday = now.subtract(Duration(days: now.weekday - 1));

      DateTime? initialDayOfWeek = await selectDate(context,
          initialDate: DateTime(monday.year, monday.month, monday.day),
          selectableDayPredicate: (date) => date.weekday == DateTime.monday,
          lastDate: lastDay);
      if (initialDayOfWeek != null) {
        if (await ViewModelTable.queryWeek(date: initialDayOfWeek)) {
          CustomRouter.instance.pushWidget(
              child: PageTable(
                title: "Seans Yönetimi",
                tableMode: TableMode.add,
                vm: ViewModelTable(week: WeekModel(daysOff: week.daysOff, days: week.days, initialDayOfWeek: initialDayOfWeek)),
              ),
              pageConfig: ConfigPopupInfo());
        } else {
          CustomRouter.instance.replacePushWidget(
              child: PagePopupInfo(
                title: "Bildirim",
                informationText: "Eklemek istediğiniz hafta zaten var. Var olan kaydı düzenleyiniz.",
                afterDelay: () => CustomRouter.instance.pop(),
              ),
              pageConfig: ConfigPopupInfo());
        }
      }
    }

    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: appState.themeData.primaryColorLight,
          scrolledUnderElevation: 0,
          leading: IconButton(onPressed: () => vm.resetAndFetchWeek(), icon: const Icon(Icons.refresh)),
          title: Text("Seans Yönetimi", style: appState.themeData.textTheme.headlineMedium),
          centerTitle: true,
          actions: [
            CustomButton(
                text: "Haftalık Seans Düzeni",
                onTap: () => CustomRouter.instance.pushWidget(
                    child: PageTable(tableMode: TableMode.empty, title: "Haftalık Seans Düzeni", vm: ViewModelTable(week: week)),
                    pageConfig: ConfigPopupInfo())),
            CustomButton(text: "Hafta Ekle", onTap: addWeekButton)
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.gapsmall),
            // Search and Filter Section
            /*SearchAndFilter(
                controller: vm.weekSearchTextEditingController, onTap: () => vm.resetAndFetchWeek(search: vm.weekSearchTextEditingController.text)),*/

            const SizedBox(height: AppTheme.gapsmall),

            // Sessions List
            Expanded(
                child: StreamBuilder<List<WeekModel>>(
                    stream: vm.weeks.stream,
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.hasData) {
                        return ListView.builder(
                            controller: vm.weekScrollController,
                            itemCount: asyncSnapshot.data?.length ?? 0, // Example data
                            itemBuilder: (context, index) {
                              return ListItemWeek(
                                  weekName: asyncSnapshot.data!.elementAt(index).getWeekRangeTitle(),
                                  onTapDetails: () => CustomRouter.instance.pushWidget(
                                      child: PageTable(
                                        tableMode: TableMode.update,
                                        title: asyncSnapshot.data!.elementAt(index).getWeekRangeTitle(),
                                        vm: ViewModelTable(week: asyncSnapshot.data!.elementAt(index)),
                                      ),
                                      pageConfig: ConfigTable));
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

/*
import 'package:flutter/material.dart';
import '/controller/app_state.dart';
import '/controller/app_theme.dart';
import '/controller/provider.dart';
import '/customWidgets/buttons/custom_button.dart';
import '/customWidgets/cards/list_item_session.dart';
import '/customWidgets/search_and_filter.dart';
import '/model/session_model.dart';
import '/navigator/custom_navigation_view.dart';
import '/navigator/ui_page.dart';
import '/network/api.dart';
import '/pages/session/session_launcher.dart';
import '/view_model/home.dart';
import '/view_model/session_details.dart';
import '../table.dart';

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
          centerTitle: true,
          actions: [
            CustomButton(
                text: "Haftalık Seans Düzeni",
                onTap: () => CustomRouter.instance.pushWidget(child: PageTable(title: "Haftalık Seans Düzeni"), pageConfig: ConfigPopupInfo())),
            CustomButton(
                text: "Hafta Ekle",
                onTap: () =>
                    CustomRouter.instance.pushWidget(child: PageTable(title: "Seans Yönetimi", sessionMode: true), pageConfig: ConfigPopupInfo()))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppTheme.gapsmall),
            // Search and Filter Section
            SearchAndFilter(
                controller: vm.sessionSearchTextEditingController, onTap: () => vm.fetchSession(search: vm.sessionSearchTextEditingController.text)),

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
                                sessionName: "-", //asyncSnapshot.data!.elementAt(index).sportType.toString(),
                                trainerName: "-", //asyncSnapshot.data!.elementAt(index).trainer.displayName,
                                date: "-", //asyncSnapshot.data!.elementAt(index).date,
                                time: "-", //"${asyncSnapshot.data!.elementAt(index).timeStart} - ${asyncSnapshot.data!.elementAt(index).timeEnd}",
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

 */
