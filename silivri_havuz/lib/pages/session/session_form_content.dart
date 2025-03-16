import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';
import '../../controller/provider.dart';
import '../../customWidgets/buttons/custom_button.dart';
import '../../customWidgets/cards/list_item_session_members.dart';
import '../../customWidgets/custom_dropdown_list.dart';
import '../../customWidgets/custom_label_textfield.dart';
import '../../utils/enums.dart';
import '../../view_model/session_details.dart';

class FormContentSession extends StatelessWidget {
  const FormContentSession({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final vm = Provider.of<ViewModelSessionDetails>(context);
    return Padding(
        padding: const EdgeInsets.all(AppTheme.gapmedium),
        child: Form(
            key: vm.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Genel bilgiler ve diğer sabit widget'lar
                Row(
                  children: [
                    Expanded(
                        child: CustomDropdownList(
                            readOnly: vm.readOnly,
                            labelText: "Spor Tipi",
                            value: vm.sessionPickedSportType.text.isNotEmpty ? vm.sessionPickedSportType.text : null,
                            list: List<String>.from(SportTypes.values.map((e) => e.toString())),
                            onChanged: (text) => vm.sessionPickedSportType.text = text!)),
                    const SizedBox(width: AppTheme.gapmedium),
                    Expanded(
                        child: vm.readOnly
                            ? CustomLabelTextField(readOnly: vm.readOnly, label: "Eğitmen Adı Soyadı", hintText: vm.selectedTrainer?.dropdownText)
                            : CustomDropdownList(
                                labelText: "Eğitmen Adı Soyadı",
                                value: vm.selectedTrainer?.dropdownText,
                                list: vm.listTrainer?.map((e) => e.dropdownText).toList() ?? [],
                                onChanged: (text) =>
                                    vm.listTrainer != null ? vm.selectedTrainer = vm.listTrainer?.firstWhere((e) => e.dropdownText == text) : null))
                  ],
                ),
                const SizedBox(height: AppTheme.gaplarge),
                Row(
                  children: [
                    Expanded(
                        child: CustomLabelTextField(
                            readOnly: vm.readOnly,
                            controller: vm.sessionPickedDate,
                            label: "Seans Tarihi",
                            suffixIcon: IconButton(
                                icon: Icon(Icons.date_range, color: appState.themeData.primaryColorDark),
                                onPressed: !vm.readOnly ? () => vm.pickDate(context) : null),
                            validator: (value) => value == null ? "Seans tarihi seçiniz" : null)),
                    const SizedBox(width: AppTheme.gapmedium),
                    Expanded(
                        child: CustomLabelTextField(
                            readOnly: vm.readOnly,
                            controller: vm.sessionPickedTimeStart,
                            label: "Başlangıç Saati",
                            suffixIcon: IconButton(
                                icon: Icon(Icons.watch_later_outlined, color: appState.themeData.primaryColorDark),
                                onPressed: vm.readOnly ? null : () => vm.pickTimeStart(context)),
                            validator: (value) => value == null ? "Başlama saati seçiniz" : null)),
                    const SizedBox(width: AppTheme.gapmedium),
                    Expanded(
                        child: CustomLabelTextField(
                            readOnly: vm.readOnly,
                            controller: vm.sessionPickedTimeEnd,
                            label: "Bitiş Saati",
                            suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.watch_later_outlined,
                                  color: appState.themeData.primaryColorDark,
                                ),
                                onPressed: vm.readOnly ? null : () => vm.pickTimeEnd(context)),
                            validator: (value) => value == null ? "Bitiş saati seçiniz" : null)),
                    const SizedBox(width: AppTheme.gapmedium),
                    Expanded(
                        child: CustomLabelTextField(
                            readOnly: vm.readOnly,
                            label: "Maksimum Katılımcı Sayısı",
                            inputFormatter: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            controller: vm.sessionCapacityController,
                            validator: (value) => value == null ? "Maksimum katılımcı sayısını giriniz" : null))
                  ],
                ),
                const SizedBox(height: AppTheme.gapmedium),
                // Üyeleri Yükle butonu ve sayım bilgileri
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(readOnly: vm.readOnly, text: "Üyeleri Yükle", onTap: () => vm.createParticipantsList()),
                    const SizedBox(height: AppTheme.gapmedium),
                    Row(
                      children: [
                        const SizedBox(width: AppTheme.gapsmall),
                        Expanded(
                            child:
                                Text("Asil Liste / Kişi Sayısı ${vm.mainMembers?.length ?? "-"}", style: appState.themeData.textTheme.headlineSmall)),
                        const SizedBox(width: AppTheme.gapxlarge),
                        Expanded(
                            child: Text("Yedek Liste / Kişi Sayısı ${vm.waitingMembers?.length ?? "-"}",
                                style: appState.themeData.textTheme.headlineSmall)),
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
                            itemCount: vm.mainMembers?.length ?? 0,
                            separatorBuilder: (context, index) => const SizedBox(height: AppTheme.gapsmall),
                            itemBuilder: (context, index) => ListItemSessionMembers(
                                  member: vm.mainMembers!.elementAt(index),
                                  onTap: () {},
                                ))),
                    const SizedBox(width: AppTheme.gapxlarge),
                    Expanded(
                        child: ListView.separated(
                            itemCount: vm.waitingMembers?.length ?? 0,
                            separatorBuilder: (context, index) => const SizedBox(height: AppTheme.gapsmall),
                            itemBuilder: (context, index) => ListItemSessionMembers(member: vm.waitingMembers!.elementAt(index), onTap: () {}))),
                  ],
                ))
              ],
            )));
  }
}
