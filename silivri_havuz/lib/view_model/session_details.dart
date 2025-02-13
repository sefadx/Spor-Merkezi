import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silivri_havuz/model/member_model.dart';
import 'package:silivri_havuz/model/session_model.dart';
import 'package:silivri_havuz/navigator/custom_navigation_view.dart';
import 'package:silivri_havuz/navigator/ui_page.dart';
import 'package:silivri_havuz/pages/alert_dialog.dart';
import 'package:silivri_havuz/view_model/home.dart';
import '../utils/extension.dart';

class ViewModelSessionDetails extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController sessionPickedDate = TextEditingController();
  final TextEditingController sessionPickedTimeStart = TextEditingController();
  final TextEditingController sessionPickedTimeEnd = TextEditingController();
  final TextEditingController sessionPickedSportType = TextEditingController();
  final TextEditingController trainerController = TextEditingController();
  final TextEditingController maxParticipantsController = TextEditingController();
  final List<MemberModel> participantsPrimaryList = [];
  final List<MemberModel> participantsReserveList = [];

  final List<String> listSpor = ['Yüzme', 'Pilates', 'Jimnastik'];

  void save() async {
    if (formKey.currentState!.validate() && sessionPickedDate.text.isNotEmpty) {
      ViewModelHome.instance.sessions.value.add(SessionModel(
          sessionName: sessionPickedSportType.text,
          trainerName: trainerController.text,
          date: format.parse(sessionPickedDate.text),
          capacity: int.tryParse(maxParticipantsController.text)!,
          participants: participantsPrimaryList));
      if (await CustomRouter.instance.waitForResult(
          const PageAlertDialog(title: "Uyarı", informationText: "Girdiğiniz bilgilere göre seans kaydı oluşturulacaktır. Onaylıyor musunuz ?"),
          ConfigAlertDialog)) {
        ViewModelHome.instance.sessions.notifyListeners();
        CustomRouter.instance.pop();
      }
    } else {}
  }

  void pickDate(BuildContext context) async {
    DateTime date = await selectDate(context, initialDate: sessionPickedDate.text != "" ? format.parse(sessionPickedDate.text) : null);
    sessionPickedDate.text = format.format(date);
    notifyListeners();
  }

  void pickTimeStart(BuildContext context) async {
    TimeOfDay time = await selectTime(context, initialTime: TimeOfDay.now());
    sessionPickedTimeStart.text = "${time.hour}:${time.minute}";
    notifyListeners();
  }

  void pickTimeEnd(BuildContext context) async {
    TimeOfDay time = await selectTime(context, initialTime: TimeOfDay.now());
    sessionPickedTimeEnd.text = "${time.hour}:${time.minute}";
    notifyListeners();
  }

  void createParticipantsList() {
    participantsPrimaryList.clear();
    participantsReserveList.clear();
    for (int i = 1; i <= (int.tryParse(maxParticipantsController.text) ?? 0); i++) {
      if (participantsPrimaryList.length < int.tryParse(maxParticipantsController.text)!) {
        participantsPrimaryList.add(MemberModel(
            identity: "12345678901",
            name: "User ",
            surname: "$i",
            birthDate: DateTime.utc(1987),
            birthPlace: "Ankara",
            gender: "Erkek",
            educationLevel: "Lisans Mezunu",
            phoneNumber: "+90(541)2345678",
            email: "test@silivri.bel.tr",
            address: "Burada açık adres bilgisi yer alacaktır",
            emergencyContactName: "SİLİVRİ DEVLET HASTANESİ AMBULANS",
            emergencyContactPhoneNumber: "112"));
      }
    }
    for (int i = (int.tryParse(maxParticipantsController.text) ?? 0) + 1; i <= (int.tryParse(maxParticipantsController.text) ?? 0) + 40; i++) {
      participantsReserveList.add(MemberModel(
          identity: "12345678901",
          name: "User ",
          surname: "$i",
          birthDate: DateTime.utc(1987),
          birthPlace: "Ankara",
          gender: "Erkek",
          educationLevel: "Lisans Mezunu",
          phoneNumber: "+90(541)2345678",
          email: "test@silivri.bel.tr",
          address: "Burada açık adres bilgisi yer alacaktır",
          emergencyContactName: "SİLİVRİ DEVLET HASTANESİ AMBULANS",
          emergencyContactPhoneNumber: "112"));
    }
    notifyListeners();
  }
}
