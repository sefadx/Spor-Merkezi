import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silivri_havuz/utils/enums.dart';

import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';
import '../../customWidgets/buttons/custom_button.dart';
import '../../customWidgets/custom_dropdown_list.dart';
import '../../customWidgets/custom_label_textfield.dart';
import '../../view_model/session_details.dart';

class PageSessionCreate extends StatefulWidget {
  const PageSessionCreate({super.key});

  @override
  State<PageSessionCreate> createState() => _PageSessionCreateState();
}

class _PageSessionCreateState extends State<PageSessionCreate> {
  bool readOnly = false;

  ViewModelSessionDetails vm = ViewModelSessionDetails();

  @override
  void initState() {
    vm.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Seans Yönetimi', style: AppState.instance.themeData.textTheme.headlineLarge)),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                child: Form(
                    key: vm.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Genel Bilgiler
                        Row(children: [
                          Expanded(
                              child: CustomDropdownList(
                                  labelText: "Spor Tipi",
                                  list: List<String>.from(SportTypes.values.map((e) => e.toString())),
                                  onChanged: (text) {
                                    vm.sessionPickedSportType.text = text!;
                                  })),
                          SizedBox(width: AppTheme.gapmedium),
                          Expanded(
                              child: CustomLabelTextField(
                                  controller: vm.trainerController,
                                  label: "Eğitmen Adı",
                                  validator: (value) => value == null ? "Eğitmen bilgisi boş olamaz." : null))
                        ]),
                        SizedBox(height: AppTheme.gaplarge),
                        Row(children: [
                          Expanded(
                              child: CustomLabelTextField(
                                  controller: vm.sessionPickedDate,
                                  label: "Seans Tarihi",
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.date_range,
                                        color: AppState.instance.themeData.primaryColorDark,
                                      ),
                                      onPressed: !readOnly
                                          ? () async {
                                              vm.pickDate(context);
                                            }
                                          : null),
                                  validator: (value) => value == null ? "Seans tarihi seçiniz" : null)),
                          const SizedBox(width: AppTheme.gapmedium),
                          Expanded(
                              child: CustomLabelTextField(
                                  controller: vm.sessionPickedTimeStart,
                                  label: "Başlangıç Saati",
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.watch_later_outlined,
                                        color: AppState.instance.themeData.primaryColorDark,
                                      ),
                                      onPressed: !readOnly
                                          ? () async {
                                              vm.pickTimeStart(context);
                                            }
                                          : null),
                                  validator: (value) => value == null ? "Başlama saati seçiniz" : null)),
                          const SizedBox(width: AppTheme.gapmedium),
                          Expanded(
                              child: CustomLabelTextField(
                                  controller: vm.sessionPickedTimeEnd,
                                  label: "Bitiş Saati",
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.watch_later_outlined,
                                        color: AppState.instance.themeData.primaryColorDark,
                                      ),
                                      onPressed: !readOnly
                                          ? () async {
                                              vm.pickTimeEnd(context);
                                            }
                                          : null),
                                  validator: (value) => value == null ? "Bitiş saati seçiniz" : null)),
                          const SizedBox(width: AppTheme.gapmedium),
                          Expanded(
                              child: CustomLabelTextField(
                                  label: "Maksimum Katılımcı Sayısı",
                                  inputFormatter: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  controller: vm.maxParticipantsController,
                                  validator: (value) => value == null ? "Maksimum katılımcı sayısını giriniz" : null)),
                        ]),
                        SizedBox(height: AppTheme.gapmedium),
                        Column(
                          children: [
                            CustomButton(
                                text: "Katılımcıları Yükle",
                                onTap: () {
                                  vm.createParticipantsList();
                                }),
                            SizedBox(height: AppTheme.gapmedium),
                            Text("Katılımcılar Listesi", style: AppState.instance.themeData.textTheme.headlineMedium),
                            SizedBox(height: AppTheme.gapmedium),
                            Row(children: [
                              SizedBox(width: AppTheme.gapsmall),
                              Expanded(
                                  child: Text("Asil Liste / Kişi Sayısı ${vm.mainMembers.length}",
                                      style: AppState.instance.themeData.textTheme.headlineSmall)),
                              SizedBox(width: AppTheme.gapxlarge),
                              Expanded(
                                  child: Text("Yedek Liste / Kişi Sayısı ${vm.waitingMembers.length}",
                                      style: AppState.instance.themeData.textTheme.headlineSmall))
                            ]),
                            SizedBox(height: AppTheme.gapmedium),
                            Material(
                                color: Colors.transparent,
                                child: ConstrainedBox(
                                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: ListView.separated(
                                                itemCount: vm.mainMembers.length,
                                                separatorBuilder: (context, index) => const SizedBox(height: AppTheme.gapsmall),
                                                itemBuilder: (context, index) {
                                                  return ListItemMemberSelected(
                                                      text: "${vm.mainMembers.elementAt(index).name} ${vm.mainMembers.elementAt(index).surname}");
                                                })),
                                        const SizedBox(width: AppTheme.gapxlarge),
                                        Expanded(
                                            child: ListView.separated(
                                                itemCount: vm.waitingMembers.length,
                                                separatorBuilder: (context, index) => const SizedBox(height: AppTheme.gapsmall),
                                                itemBuilder: (context, index) {
                                                  return ListItemMemberSelected(
                                                      text:
                                                          "${vm.waitingMembers.elementAt(index).name} ${vm.waitingMembers.elementAt(index).surname}");
                                                }))
                                      ],
                                    )))
                          ],
                        ),
                        SizedBox(height: AppTheme.gaplarge),
                        // Kaydet Butonu
                        Row(children: [
                          Expanded(
                              child: CustomButton(
                                  text: "Seansı Kaydet",
                                  onTap: () {
                                    vm.save();
                                  }))
                        ])
                      ],
                    )))));
  }
}

class ListItemMemberSelected extends StatelessWidget {
  const ListItemMemberSelected({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Ink(
        padding: const EdgeInsets.all(AppTheme.gapsmall),
        decoration: AppTheme.buttonPrimaryDecoration,
        child: Text(text, style: AppState.instance.themeData.textTheme.bodyMedium));
  }
}
