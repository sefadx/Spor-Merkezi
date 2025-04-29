import 'package:flutter/material.dart';
import 'package:silivri_havuz/view_model/session_details.dart';
import '../customWidgets/buttons/custom_button.dart';
import '/model/table_model.dart';
import '/pages/widget_popup.dart';
import '/customWidgets/custom_dropdown_list.dart';
import '/utils/enums.dart';
import '/view_model/table.dart';
import '/navigator/custom_navigation_view.dart';
import '/navigator/ui_page.dart';
import '/controller/app_state.dart';
import '/controller/app_theme.dart';
import '/controller/provider.dart';
import 'session/session_launcher.dart';

enum TableMode { empty, add, update }

class PageTable extends StatelessWidget {
  const PageTable({required this.vm, this.title, this.tableMode = TableMode.empty, super.key});
  //final void Function()? onTapCell;

  final ViewModelTable vm;
  final String? title;
  //final bool addWeekMode; //true ise seans ekle vey güncelle olarak çalışıyor değilse defaul senas düzeni var.
  final TableMode tableMode;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Provider<ViewModelTable>(
      model: vm,
      child: Scaffold(
          backgroundColor: appState.themeData.scaffoldBackgroundColor,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(title ?? "", style: appState.themeData.textTheme.headlineMedium),
            centerTitle: true,
            actions: switch (tableMode) {
              TableMode.add => [
                  CustomButton(text: "Haftayı ekle", margin: const EdgeInsets.only(right: AppTheme.gapsmall), onTap: () async => await vm.postWeek())
                ],
              TableMode.update => [
                  CustomButton(
                      text: "Haftayı Güncelle", margin: const EdgeInsets.only(right: AppTheme.gapsmall), onTap: () async => await vm.updateWeek())
                ],
              TableMode.empty => null
            },
          ),
          body: _PageTableBody(
            tableMode: tableMode,
          )),
    );
  }
}

class _PageTableBody extends StatelessWidget {
  const _PageTableBody({required this.tableMode});
  //final void Function()? onTapCell;
  final TableMode tableMode;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final vm = Provider.of<ViewModelTable>(context);
    return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 875),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Ink(
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.gapmedium, horizontal: AppTheme.gapxsmall),
                        child: Center(child: Text("SAAT", textAlign: TextAlign.center, style: appState.themeData.textTheme.headlineSmall))),
                    Expanded(
                        child: Material(
                            child: ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 120),
                                    child: ListView.builder(
                                        shrinkWrap: false,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: vm.timeSlots.length,
                                        itemBuilder: (context, index) => vm.timeSlots.elementAt(index).isBreak
                                            ? Ink(
                                                padding: const EdgeInsets.all(AppTheme.gapxxsmall),
                                                color: Colors.grey,
                                                child: Text("${vm.timeSlots.elementAt(index).start} - ${vm.timeSlots.elementAt(index).end}",
                                                    style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center))
                                            : Ink(
                                                padding: const EdgeInsets.symmetric(vertical: AppTheme.gaplarge, horizontal: AppTheme.gapxsmall),
                                                height: 70,
                                                color: AppTheme.blackWhite(context),
                                                child: Center(
                                                  child: Text("${vm.timeSlots.elementAt(index).start} - ${vm.timeSlots.elementAt(index).end}",
                                                      style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                                                )))))))
                  ],
                ),
                Expanded(
                    child: Material(
                        child: ListView.separated(
                            shrinkWrap: false,
                            padding: const EdgeInsets.symmetric(horizontal: AppTheme.gapxsmall),
                            scrollDirection: Axis.horizontal,
                            itemCount: vm.week.days.length,
                            separatorBuilder: (context, index) => const SizedBox(width: AppTheme.gapxsmall),
                            itemBuilder: (context, index) => Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                        onTap: () => vm.setDaysOff(index),
                                        child: Ink(
                                            width: 170,
                                            padding: const EdgeInsets.symmetric(vertical: AppTheme.gapmedium, horizontal: AppTheme.gapxsmall),
                                            color: vm.getDaysOff(index) ? Colors.red.shade800 : null,
                                            child: Text(vm.week.days.elementAt(index).name,
                                                textAlign: TextAlign.center, style: appState.themeData.textTheme.headlineSmall))),
                                    if (!vm.getDaysOff(index)) //0 pazartesi anlamına geliyor
                                      Expanded(
                                          child: Material(
                                              child: ScrollConfiguration(
                                                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                                  child: ConstrainedBox(
                                                      constraints: const BoxConstraints(maxWidth: 170),
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemCount: vm.week.days
                                                              .elementAt(index)
                                                              .activities
                                                              .length, //week.days.elementAt(index).activities.length,
                                                          itemBuilder: (context, indexActivities) => vm.week.days
                                                                      .elementAt(index)
                                                                      .activities
                                                                      .elementAt(indexActivities) ==
                                                                  null
                                                              ? Ink(
                                                                  padding: const EdgeInsets.all(AppTheme.gapxxsmall),
                                                                  color: Colors.grey,
                                                                  child: Text("Seans arası",
                                                                      style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center))
                                                              : InkWell(
                                                                  onTap: switch (tableMode) {
                                                                    TableMode.empty => () => CustomRouter.instance.pushWidget(
                                                                        child: PagePopupWidget(
                                                                          title: "Seans Bilgileri",
                                                                          widget: Padding(
                                                                              padding: const EdgeInsets.all(AppTheme.gapmedium),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  CustomDropdownList(
                                                                                      readOnly: false,
                                                                                      labelText: "Kategori",
                                                                                      value: vm.week.days
                                                                                          .elementAt(index)
                                                                                          .activities
                                                                                          .elementAt(indexActivities)!
                                                                                          .type
                                                                                          .toString(),
                                                                                      list: List<String>.from(
                                                                                          ActivityType.values.map((e) => e.toString())),
                                                                                      onChanged: (text) => vm.setActivity(
                                                                                          Activity(
                                                                                              type: ActivityType.fromString(text!),
                                                                                              ageGroup: vm.week.days
                                                                                                  .elementAt(index)
                                                                                                  .activities
                                                                                                  .elementAt(indexActivities)!
                                                                                                  .ageGroup,
                                                                                              fee: vm.week.days
                                                                                                  .elementAt(index)
                                                                                                  .activities
                                                                                                  .elementAt(indexActivities)!
                                                                                                  .fee),
                                                                                          index,
                                                                                          indexActivities)),
                                                                                  const SizedBox(height: AppTheme.gapsmall),
                                                                                  CustomDropdownList(
                                                                                      readOnly: false,
                                                                                      labelText: "Grup",
                                                                                      value: vm.week.days
                                                                                          .elementAt(index)
                                                                                          .activities
                                                                                          .elementAt(indexActivities)!
                                                                                          .ageGroup
                                                                                          .toString(),
                                                                                      list:
                                                                                          List<String>.from(AgeGroup.values.map((e) => e.toString())),
                                                                                      onChanged: (text) => vm.setActivity(
                                                                                          Activity(
                                                                                              type: vm.week.days
                                                                                                  .elementAt(index)
                                                                                                  .activities
                                                                                                  .elementAt(indexActivities)!
                                                                                                  .type,
                                                                                              ageGroup: AgeGroup.fromString(text!),
                                                                                              fee: vm.week.days
                                                                                                  .elementAt(index)
                                                                                                  .activities
                                                                                                  .elementAt(indexActivities)!
                                                                                                  .fee),
                                                                                          index,
                                                                                          indexActivities)),
                                                                                  const SizedBox(height: AppTheme.gapsmall),
                                                                                  CustomDropdownList(
                                                                                      readOnly: false,
                                                                                      labelText: "Ücret",
                                                                                      value: vm.week.days
                                                                                          .elementAt(index)
                                                                                          .activities
                                                                                          .elementAt(indexActivities)!
                                                                                          .fee
                                                                                          .toString(),
                                                                                      list:
                                                                                          List<String>.from(FeeType.values.map((e) => e.toString())),
                                                                                      onChanged: (text) => vm.setActivity(
                                                                                          Activity(
                                                                                              type: vm.week.days
                                                                                                  .elementAt(index)
                                                                                                  .activities
                                                                                                  .elementAt(indexActivities)!
                                                                                                  .type,
                                                                                              ageGroup: vm.week.days
                                                                                                  .elementAt(index)
                                                                                                  .activities
                                                                                                  .elementAt(indexActivities)!
                                                                                                  .ageGroup,
                                                                                              fee: FeeType.fromString(text!)),
                                                                                          index,
                                                                                          indexActivities)),
                                                                                  const SizedBox(height: AppTheme.gapxsmall),
                                                                                ],
                                                                              )),
                                                                        ),
                                                                        pageConfig: ConfigPopupInfo()),
                                                                    TableMode.add => () {
                                                                        vm.selectedDayIndex = index;
                                                                        vm.selectedActivityIndex = indexActivities;

                                                                        CustomRouter.instance.pushWidget(
                                                                            child: Provider<ViewModelTable>(
                                                                                model: vm,
                                                                                child: PageSessionLauncher(
                                                                                  vmSession: ViewModelSessionDetails(
                                                                                      model: vm.week.days
                                                                                          .elementAt(vm.selectedDayIndex!)
                                                                                          .activities
                                                                                          .elementAt(indexActivities)!
                                                                                          .sessionModel),
                                                                                )),
                                                                            pageConfig: ConfigSessionCreate);
                                                                      },
                                                                    TableMode.update => () {
                                                                        vm.selectedDayIndex = index;
                                                                        vm.selectedActivityIndex = indexActivities;

                                                                        CustomRouter.instance.pushWidget(
                                                                            child: Provider<ViewModelTable>(
                                                                                model: vm,
                                                                                child: PageSessionLauncher(
                                                                                    vmSession: ViewModelSessionDetails(
                                                                                        model: vm.week.days
                                                                                            .elementAt(vm.selectedDayIndex!)
                                                                                            .activities
                                                                                            .elementAt(indexActivities)!
                                                                                            .sessionModel))),
                                                                            pageConfig: ConfigSessionCreate);
                                                                      },
                                                                  },
                                                                  child: Ink(
                                                                      padding: const EdgeInsets.symmetric(
                                                                          vertical: AppTheme.gapxxsmall, horizontal: AppTheme.gapxsmall),
                                                                      height: 70,
                                                                      color: vm.week.days
                                                                          .elementAt(index)
                                                                          .activities
                                                                          .elementAt(indexActivities)!
                                                                          .type
                                                                          .getBackgroundColor(), //appState.themeData.primaryColorLight,
                                                                      child: Column(
                                                                        children: [
                                                                          Text(
                                                                              "${vm.week.days.elementAt(index).activities.elementAt(indexActivities)!.type} (${vm.week.days.elementAt(index).activities.elementAt(indexActivities)!.sessionModel?.mainMembers.length.toString() ?? "0"})",
                                                                              style: appState.themeData.textTheme.bodyMedium,
                                                                              textAlign: TextAlign.center),
                                                                          Text(
                                                                              vm.week.days
                                                                                  .elementAt(index)
                                                                                  .activities
                                                                                  .elementAt(indexActivities)!
                                                                                  .ageGroup
                                                                                  .toString(),
                                                                              style: appState.themeData.textTheme.bodyMedium,
                                                                              textAlign: TextAlign.center),
                                                                          Text(
                                                                              vm.week.days
                                                                                  .elementAt(index)
                                                                                  .activities
                                                                                  .elementAt(indexActivities)!
                                                                                  .fee
                                                                                  .toString(),
                                                                              style: appState.themeData.textTheme.bodyMedium,
                                                                              textAlign: TextAlign.center),
                                                                        ],
                                                                      ))))))))
                                    else
                                      Expanded(
                                          child: Center(
                                        child: Ink(
                                            width: 170,
                                            padding: const EdgeInsets.all(AppTheme.gapxxsmall),
                                            child: Text("Tesis Bakım\nve\nTemizlik",
                                                style: appState.themeData.textTheme.bodyLarge, textAlign: TextAlign.center)),
                                      ))
                                  ],
                                ))))
              ],
            )));
  }
}

/*
class PageTable extends StatelessWidget {
  PageTable({super.key});

  final DateTime date = DateTime(2025);
  final scrollController = ScrollController(initialScrollOffset: (DateTime.now().difference(DateTime(2025, 1, 1)).inDays * 177) - 170);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Material(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Ink(
                padding: const EdgeInsets.symmetric(vertical: AppTheme.gapmedium, horizontal: AppTheme.gapxsmall),
                child: Center(child: Text("SAAT\n", textAlign: TextAlign.center, style: appState.themeData.textTheme.headlineSmall))),
            ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: timeSlots.length,
                    itemBuilder: (context, index) => timeSlots.elementAt(index).isBreak
                        ? Ink(
                            padding: const EdgeInsets.all(AppTheme.gapxxsmall),
                            color: Colors.grey,
                            child: Text("${timeSlots.elementAt(index).start} - ${timeSlots.elementAt(index).end}",
                                style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center))
                        : Ink(
                            padding: const EdgeInsets.symmetric(vertical: AppTheme.gaplarge, horizontal: AppTheme.gapxsmall),
                            height: 70,
                            color: AppTheme.blackWhite(context),
                            child: Center(
                              child: Text("${timeSlots.elementAt(index).start} - ${timeSlots.elementAt(index).end}",
                                  style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                            ))))
          ],
        ),
        Expanded(
            child: Material(
          child: ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.gapxsmall),
              scrollDirection: Axis.horizontal,
              itemCount: 365,
              separatorBuilder: (context, index) => const SizedBox(width: AppTheme.gapxsmall),
              itemBuilder: (context, index) {
                final dateLocal = date.add(Duration(days: index));

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Ink(
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.gapmedium, horizontal: AppTheme.gapxsmall),
                        child: Text("${dateFormat.format(dateLocal)}\n${dayFormat.format(dateLocal)}",
                            textAlign: TextAlign.center, style: appState.themeData.textTheme.headlineSmall)),
                    if (dateLocal.weekday != 1)
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 170),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 17, //week.days.elementAt(index).activities.length,
                              itemBuilder: (context, indexActivities) => week.days
                                          .elementAt(dateLocal.weekday - 1)
                                          .activities
                                          .elementAt(indexActivities) ==
                                      null
                                  ? Ink(
                                      padding: const EdgeInsets.all(AppTheme.gapxxsmall),
                                      color: Colors.grey,
                                      child: Text("Seans arası", style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center))
                                  : Ink(
                                      padding: const EdgeInsets.symmetric(vertical: AppTheme.gapxxsmall, horizontal: AppTheme.gapxsmall),
                                      height: 70,
                                      color: week.days
                                          .elementAt(dateLocal.weekday - 1)
                                          .activities
                                          .elementAt(indexActivities)!
                                          .type
                                          .getBackgroundColor(), //appState.themeData.primaryColorLight,
                                      child: Column(
                                        children: [
                                          Text(week.days.elementAt(dateLocal.weekday - 1).activities.elementAt(indexActivities)!.type.toString(),
                                              style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                                          Text(week.days.elementAt(dateLocal.weekday - 1).activities.elementAt(indexActivities)!.ageGroup.toString(),
                                              style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                                          Text(week.days.elementAt(dateLocal.weekday - 1).activities.elementAt(indexActivities)!.fee.toString(),
                                              style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                                        ],
                                      ))))
                    else
                      Expanded(
                          child: Center(
                        child: Ink(
                            width: 170,
                            padding: const EdgeInsets.all(AppTheme.gapxxsmall),
                            child: Text("Hafta Tatili", style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center)),
                      ))
                  ],
                );
              }),
        ))
      ],
    ));
  }
}

 */
