import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../view_model/session_details.dart';
import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';
import '../../customWidgets/buttons/custom_button.dart';
import '../../customWidgets/cards/list_item_session_members.dart';
import '../../customWidgets/custom_dropdown_list.dart';
import '../../customWidgets/custom_label_textfield.dart';
import '../../utils/enums.dart';

class FormContentSession extends StatefulWidget {
  const FormContentSession({required this.vm, super.key});

  final ViewModelSessionDetails vm;

  @override
  State<FormContentSession> createState() => _FormContentSessionState();
}

class _FormContentSessionState extends State<FormContentSession> {
  @override
  void initState() {
    widget.vm.addListener(() {
      debugPrint("setState runned");
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.vm.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Genel bilgiler ve diğer sabit widget'lar
            Row(
              children: [
                Expanded(
                  child: CustomDropdownList(
                    labelText: "Spor Tipi",
                    value: widget.vm.sessionPickedSportType.text.isNotEmpty ? widget.vm.sessionPickedSportType.text : null,
                    list: List<String>.from(SportTypes.values.map((e) => e.toString())),
                    onChanged: (text) {
                      widget.vm.sessionPickedSportType.text = text!;
                    },
                  ),
                ),
                const SizedBox(width: AppTheme.gapmedium),
                Expanded(
                  child: widget.vm.readOnly
                      ? CustomLabelTextField(
                          readOnly: widget.vm.readOnly,
                          label: "Eğitmen Adı Soyadı",
                          hintText: widget.vm.selectedTrainer?.dropdownText,
                        )
                      : CustomDropdownList(
                          labelText: "Eğitmen Adı Soyadı",
                          value: widget.vm.selectedTrainer?.dropdownText,
                          list: widget.vm.listTrainer?.map((e) => e.dropdownText).toList() ?? [],
                          onChanged: (text) {
                            widget.vm.listTrainer != null
                                ? widget.vm.selectedTrainer = widget.vm.listTrainer?.firstWhere((e) => e.dropdownText == text)
                                : null;
                          },
                        ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.gaplarge),
            Row(
              children: [
                Expanded(
                  child: CustomLabelTextField(
                    controller: widget.vm.sessionPickedDate,
                    label: "Seans Tarihi",
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.date_range,
                        color: AppState.instance.themeData.primaryColorDark,
                      ),
                      onPressed: !widget.vm.readOnly
                          ? () async {
                              widget.vm.pickDate(context);
                            }
                          : null,
                    ),
                    validator: (value) => value == null ? "Seans tarihi seçiniz" : null,
                  ),
                ),
                const SizedBox(width: AppTheme.gapmedium),
                Expanded(
                  child: CustomLabelTextField(
                    controller: widget.vm.sessionPickedTimeStart,
                    label: "Başlangıç Saati",
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.watch_later_outlined,
                        color: AppState.instance.themeData.primaryColorDark,
                      ),
                      onPressed: !widget.vm.readOnly
                          ? () async {
                              widget.vm.pickTimeStart(context);
                            }
                          : null,
                    ),
                    validator: (value) => value == null ? "Başlama saati seçiniz" : null,
                  ),
                ),
                const SizedBox(width: AppTheme.gapmedium),
                Expanded(
                  child: CustomLabelTextField(
                    controller: widget.vm.sessionPickedTimeEnd,
                    label: "Bitiş Saati",
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.watch_later_outlined,
                        color: AppState.instance.themeData.primaryColorDark,
                      ),
                      onPressed: !widget.vm.readOnly
                          ? () async {
                              widget.vm.pickTimeEnd(context);
                            }
                          : null,
                    ),
                    validator: (value) => value == null ? "Bitiş saati seçiniz" : null,
                  ),
                ),
                const SizedBox(width: AppTheme.gapmedium),
                Expanded(
                  child: CustomLabelTextField(
                    label: "Maksimum Katılımcı Sayısı",
                    inputFormatter: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    controller: widget.vm.sessionCapacityController,
                    validator: (value) => value == null ? "Maksimum katılımcı sayısını giriniz" : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.gapmedium),
            // Üyeleri Yükle butonu ve sayım bilgileri
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomButton(
                  text: "Üyeleri Yükle",
                  onTap: () {
                    widget.vm.createParticipantsList();
                  },
                ),
                const SizedBox(height: AppTheme.gapmedium),
                Row(
                  children: [
                    const SizedBox(width: AppTheme.gapsmall),
                    Expanded(
                      child: Text(
                        "Asil Liste / Kişi Sayısı ${widget.vm.mainMembers?.length ?? "-"}",
                        style: AppState.instance.themeData.textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(width: AppTheme.gapxlarge),
                    Expanded(
                      child: Text(
                        "Yedek Liste / Kişi Sayısı ${widget.vm.waitingMembers?.length ?? "-"}",
                        style: AppState.instance.themeData.textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppTheme.gapmedium),
            // Listelerin bulunduğu alanı Expanded ile sarıyoruz
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: widget.vm.mainMembers?.length ?? 0,
                      separatorBuilder: (context, index) => const SizedBox(height: AppTheme.gapsmall),
                      itemBuilder: (context, index) {
                        return ListItemMemberSelected(member: widget.vm.mainMembers!.elementAt(index));
                      },
                    ),
                  ),
                  const SizedBox(width: AppTheme.gapxlarge),
                  Expanded(
                    child: ListView.separated(
                      itemCount: widget.vm.waitingMembers?.length ?? 0,
                      separatorBuilder: (context, index) => const SizedBox(height: AppTheme.gapsmall),
                      itemBuilder: (context, index) {
                        return ListItemMemberSelected(member: widget.vm.waitingMembers!.elementAt(index));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
