import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../network/api.dart';
import '../model/member_model.dart';
import '../model/session_model.dart';
import '../navigator/custom_navigation_view.dart';
import '../navigator/ui_page.dart';
import '../pages/alert_dialog.dart';
import '../pages/info_popup.dart';
import '../view_model/home.dart';
import '../utils/extension.dart';

class ViewModelSessionDetails extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  DateTime _dateTimeStart = DateTime.now();
  DateTime _dateTimeEnd = DateTime.now();

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
      if (await CustomRouter.instance.waitForResult(
          const PageAlertDialog(title: "Uyarı", informationText: "Girdiğiniz bilgilere göre seans kaydı oluşturulacaktır. Onaylıyor musunuz ?"),
          ConfigAlertDialog)) {
        SessionModel model = SessionModel(
            sessionName: sessionPickedSportType.text,
            trainerName: trainerController.text,
            dateTimeStart: format.parse(sessionPickedTimeStart.text),
            dateTimeEnd: format.parse(sessionPickedTimeEnd.text),
            capacity: int.tryParse(maxParticipantsController.text)!,
            participants: participantsPrimaryList);

        BaseResponseModel res = await APIService<SessionModel>(url: APIS.api.session())
            .post(model)
            .onError((error, stackTrace) => BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu"));

        if (res.success) {
          ViewModelHome.instance.fetchMember();

          CustomRouter.instance.replacePushWidget(
              child: PagePopupInfo(
                title: "Bildirim",
                informationText: res.message.toString(),
                afterDelay: () => CustomRouter.instance.pop(),
              ),
              pageConfig: ConfigPopupInfo);
        } else {
          CustomRouter.instance.pushWidget(
              child: PagePopupInfo(
                title: "Bildirim",
                informationText: res.message.toString(),
              ),
              pageConfig: ConfigPopupInfo);
        }
      }
    }
  }

  void pickDate(BuildContext context) async {
    _dateTimeStart = await selectDate(context, initialDate: sessionPickedDate.text != "" ? format.parse(sessionPickedDate.text) : null);
    sessionPickedDate.text = format.format(_dateTimeStart);
    notifyListeners();
  }

  void pickTimeStart(BuildContext context) async {
    TimeOfDay time = await selectTime(context, initialTime: TimeOfDay.now());
    _dateTimeStart = DateTime(_dateTimeStart.year, _dateTimeStart.month, _dateTimeStart.day, time.hour, time.minute);
    sessionPickedTimeStart.text = "${time.hour}:${time.minute}";
    notifyListeners();
  }

  void pickTimeEnd(BuildContext context) async {
    TimeOfDay time = await selectTime(context, initialTime: TimeOfDay.now());
    _dateTimeEnd = DateTime(_dateTimeStart.year, _dateTimeStart.month, _dateTimeStart.day, time.hour, time.minute);
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
