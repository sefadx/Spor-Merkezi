import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/controller/app_state.dart';
import '/controller/app_theme.dart';
import '/controller/provider.dart';
import '/customWidgets/buttons/custom_button.dart';
import '/customWidgets/cards/list_item_session_members.dart';
import '/customWidgets/custom_dropdown_list.dart';
import '/customWidgets/custom_label_textfield.dart';
import '/model/session_model.dart';
import '/model/table_model.dart';
import '/navigator/custom_navigation_view.dart';
import '/navigator/ui_page.dart';
import '/utils/enums.dart';
import '/view_model/member_details.dart';
import '/view_model/session_details.dart';
import '/view_model/table.dart';
import '../member/member_launcher.dart';

class PageSessionLauncher extends StatelessWidget {
  //PageSessionLauncher({ViewModelSessionDetails? model, required this.vmTable, super.key}) {
  PageSessionLauncher({required this.vmSession, super.key});
  ViewModelSessionDetails vmSession;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final vmTable = Provider.of<ViewModelTable>(context);
    /*if (vmTable.week.days.elementAt(vmTable.selectedDayIndex!).activities.elementAt(vmTable.selectedActivityIndex!)!.sessionModel != null) {
      vmSession = ViewModelSessionDetails.fromModel(
          model: vmTable.week.days.elementAt(vmTable.selectedDayIndex!).activities.elementAt(vmTable.selectedActivityIndex!)!.sessionModel!);
    } else {
      vmSession = ViewModelSessionDetails();
    }*/
    return Provider<ViewModelSessionDetails>(
        model: vmSession,
        child: Scaffold(
            backgroundColor: appState.themeData.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: appState.themeData.scaffoldBackgroundColor,
              scrolledUnderElevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Seans Yönetimi - ${vmTable.week.days.elementAt(vmTable.selectedDayIndex!).name} ${vmTable.timeSlots.elementAt(vmTable.selectedActivityIndex!).start}-${vmTable.timeSlots.elementAt(vmTable.selectedActivityIndex!).end}',
                      style: appState.themeData.textTheme.headlineMedium),
                  const SizedBox(width: AppTheme.gaplarge),
                  CustomButton(
                      text:
                          "Düzenle", //vmSession.readOnly ? "Seansı Güncelle" : "Seansı kaydet",
                      margin: const EdgeInsets.only(right: AppTheme.gapsmall),
                      onTap: () {
                        vmSession.readOnly = !vmSession.readOnly;
                        vmTable.updateProvider();
                        debugPrint(
                            "vmSession.readOnly : ${vmSession.readOnly}");
                      })
                ],
              ),
              actions: !vmSession.readOnly
                  ? [
                      CustomButton(
                          readOnly: vmSession.readOnly,
                          text:
                              "Seansı kaydet", //vmSession.readOnly ? "Seansı Güncelle" : "Seansı kaydet",
                          margin:
                              const EdgeInsets.only(right: AppTheme.gapsmall),
                          onTap: () {
                            vmTable.setSessionModel(
                                model: SessionModel(
                                    dateTimeStart: vmTable.timeSlots
                                        .elementAt(
                                            vmTable.selectedActivityIndex!)
                                        .start,
                                    dateTimeEnd: vmTable.timeSlots
                                        .elementAt(
                                            vmTable.selectedActivityIndex!)
                                        .end,
                                    capacity: int.tryParse(vmSession
                                            .sessionCapacityController.text) ??
                                        0,
                                    mainMembers: vmSession.mainMembers ?? [],
                                    waitingMembers:
                                        vmSession.waitingMembers ?? []));

                            CustomRouter.instance.pop();
                          })
                    ]
                  : null,
            ),
            body: const _FormContentSession()));
  }
}

class _FormContentSession extends StatelessWidget {
  const _FormContentSession();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final vmSession = Provider.of<ViewModelSessionDetails>(context);
    final vmTable = Provider.of<ViewModelTable>(context);

    return Padding(
        padding: const EdgeInsets.all(AppTheme.gapmedium),
        child: Form(
            key: vmSession.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Genel bilgiler ve diğer sabit widget'lar
                Row(
                  children: [
                    Expanded(
                        child: CustomDropdownList(
                            readOnly: vmSession.readOnly,
                            labelText: "Kategori",
                            value: vmTable.week.days
                                .elementAt(vmTable.selectedDayIndex!)
                                .activities
                                .elementAt(vmTable.selectedActivityIndex!)!
                                .type
                                .toString(),
                            list: List<String>.from(
                                ActivityType.values.map((e) => e.toString())),
                            onChanged: (text) => vmTable.setActivity(
                                Activity(
                                    type: ActivityType.fromString(text!),
                                    ageGroup: vmTable.week.days
                                        .elementAt(vmTable.selectedDayIndex!)
                                        .activities
                                        .elementAt(
                                            vmTable.selectedActivityIndex!)!
                                        .ageGroup,
                                    fee: vmTable.week.days
                                        .elementAt(vmTable.selectedDayIndex!)
                                        .activities
                                        .elementAt(
                                            vmTable.selectedActivityIndex!)!
                                        .fee),
                                vmTable.selectedDayIndex!,
                                vmTable.selectedActivityIndex!))),
                    const SizedBox(width: AppTheme.gapsmall),
                    Expanded(
                        child: CustomDropdownList(
                            readOnly: vmSession.readOnly,
                            labelText: "Grup",
                            value: vmTable.week.days
                                .elementAt(vmTable.selectedDayIndex!)
                                .activities
                                .elementAt(vmTable.selectedActivityIndex!)!
                                .ageGroup
                                .toString(),
                            list: List<String>.from(
                                AgeGroup.values.map((e) => e.toString())),
                            onChanged: (text) => vmTable.setActivity(
                                Activity(
                                    type: vmTable.week.days
                                        .elementAt(vmTable.selectedDayIndex!)
                                        .activities
                                        .elementAt(
                                            vmTable.selectedActivityIndex!)!
                                        .type,
                                    ageGroup: AgeGroup.fromString(text!),
                                    fee: vmTable.week.days
                                        .elementAt(vmTable.selectedDayIndex!)
                                        .activities
                                        .elementAt(
                                            vmTable.selectedActivityIndex!)!
                                        .fee),
                                //vmSession.model.dayIndex,
                                vmTable.selectedDayIndex!,
                                vmTable
                                    .selectedActivityIndex!))), //vmSession.model.activityIndex)),
                    const SizedBox(width: AppTheme.gapsmall),
                    Expanded(
                        child: CustomDropdownList(
                            readOnly: vmSession.readOnly,
                            labelText: "Ücret",
                            value: vmTable.week.days
                                .elementAt(vmTable.selectedDayIndex!)
                                .activities
                                .elementAt(vmTable.selectedActivityIndex!)!
                                .fee
                                .toString(),
                            list: List<String>.from(
                                FeeType.values.map((e) => e.toString())),
                            onChanged: (text) => vmTable.setActivity(
                                Activity(
                                    type: vmTable.week.days
                                        .elementAt(vmTable.selectedDayIndex!)
                                        .activities
                                        .elementAt(
                                            vmTable.selectedActivityIndex!)!
                                        .type,
                                    ageGroup: vmTable.week.days
                                        .elementAt(vmTable.selectedDayIndex!)
                                        .activities
                                        .elementAt(
                                            vmTable.selectedActivityIndex!)!
                                        .ageGroup,
                                    fee: FeeType.fromString(text!)),
                                vmTable.selectedDayIndex!,
                                vmTable.selectedActivityIndex!))),
                    const SizedBox(width: AppTheme.gapsmall),
                    Expanded(
                        child: CustomLabelTextField(
                            readOnly: vmSession.readOnly,
                            label: "Maksimum Katılımcı Sayısı",
                            inputFormatter: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: vmSession.sessionCapacityController,
                            validator: (value) => value == null
                                ? "Maksimum katılımcı sayısını giriniz"
                                : null))
                  ],
                ),
                const SizedBox(height: AppTheme.gaplarge),

                // Üyeleri Yükle butonu ve sayım bilgileri
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    !vmSession.readOnly
                        ? CustomButton(
                            readOnly: vmSession.readOnly,
                            text: "Üyeleri Yükle",
                            onTap: () => vmSession.createParticipantsList(
                                type: vmTable.week.days
                                    .elementAt(vmTable.selectedDayIndex!)
                                    .activities
                                    .elementAt(vmTable.selectedActivityIndex!)!
                                    .type,
                                age: vmTable.week.days
                                    .elementAt(vmTable.selectedDayIndex!)
                                    .activities
                                    .elementAt(vmTable.selectedActivityIndex!)!
                                    .ageGroup,
                                fee: vmTable.week.days
                                    .elementAt(vmTable.selectedDayIndex!)
                                    .activities
                                    .elementAt(vmTable.selectedActivityIndex!)!
                                    .fee))
                        : const SizedBox(),
                    const SizedBox(height: AppTheme.gapmedium),
                    Row(
                      children: [
                        const SizedBox(width: AppTheme.gapsmall),
                        Expanded(
                            child: Text(
                                "Asil Liste / Kişi Sayısı ${vmSession.mainMembers?.length ?? "-"}",
                                style: appState
                                    .themeData.textTheme.headlineSmall)),
                        const SizedBox(width: AppTheme.gapxlarge),
                        Expanded(
                            child: Text(
                                "Yedek Liste / Kişi Sayısı ${vmSession.waitingMembers?.length ?? "-"}",
                                style: appState
                                    .themeData.textTheme.headlineSmall)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: AppTheme.gapmedium),
                // Listelerin bulunduğu alanı Expanded ile sarıyoruz
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                        child: ListView.separated(
                            itemCount: vmSession.mainMembers?.length ?? 0,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppTheme.gapsmall),
                            itemBuilder: (context, index) =>
                                ListItemSessionMembers(
                                  member:
                                      vmSession.mainMembers!.elementAt(index),
                                  onTap: () => CustomRouter.instance.pushWidget(
                                      child: PageMemberLauncher(
                                          model:
                                              ViewModelMemberDetails.fromModel(
                                                  memberModel: vmSession
                                                      .waitingMembers!
                                                      .elementAt(index))),
                                      pageConfig: ConfigMemberDetails),
                                ))),
                    const SizedBox(width: AppTheme.gapxlarge),
                    Expanded(
                        child: ListView.separated(
                            itemCount: vmSession.waitingMembers?.length ?? 0,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppTheme.gapsmall),
                            itemBuilder: (context, index) =>
                                ListItemSessionMembers(
                                    member: vmSession
                                        .waitingMembers!
                                        .elementAt(index),
                                    onTap: () => CustomRouter.instance.pushWidget(
                                        child: PageMemberLauncher(
                                            model:
                                                ViewModelMemberDetails.fromModel(
                                                    memberModel: vmSession
                                                        .waitingMembers!
                                                        .elementAt(index))),
                                        pageConfig: ConfigMemberDetails)))),
                  ],
                ))
              ],
            )));
  }
}

/*
import 'package:flutter/material.dart';
import 'package:silivri_havuz/view_model.dart';

import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';
import '../../controller/provider.dart';
import '../../customWidgets/buttons/custom_button.dart';
import '../../pages/session/session_form_content.dart';
import '../../view_model/session_details.dart';

class PageSessionLauncher extends StatelessWidget {
  PageSessionLauncher({ViewModelSessionDetails? model, super.key}) {
    vm = model ?? ViewModelSessionDetails();
  }

  late final ViewModelSessionDetails vm;


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Provider(
      model: vm,
      child: Scaffold(
        backgroundColor: appState.themeData.scaffoldBackgroundColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text('Seans Yönetimi', style: appState.themeData.textTheme.headlineLarge),
          actions: [
            CustomButton(
                readOnly: vm.readOnly,
                text: vm.readOnly ? "Seansı Güncelle" : "Seansı Oluştur",
                margin: const EdgeInsets.only(right: AppTheme.gapsmall),
                onTap: () => vm.onSave())
          ],
        ),
        body: const FormContentSession(),
      ),
    );
  }
}
*/
