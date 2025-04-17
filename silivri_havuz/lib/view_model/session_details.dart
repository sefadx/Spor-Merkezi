import 'package:flutter/material.dart';
import 'package:silivri_havuz/view_model/table.dart';

import '../../model/subscription_model.dart';
import '../../model/trainer_model.dart';
import '../../utils/enums.dart';
import '../model/member_model.dart';
import '../model/session_model.dart';
import '../model/table_model.dart';
import '../navigator/custom_navigation_view.dart';
import '../navigator/ui_page.dart';
import '../network/api.dart';
import '../pages/alert_dialog.dart';
import '../pages/info_popup.dart';
import '../utils/extension.dart';
import '../view_model/home.dart';

class ViewModelSessionDetails extends ChangeNotifier {
  ViewModelSessionDetails({this.readOnly = false});
  ViewModelSessionDetails.fromModel({this.readOnly = true, required this.model}) {
    sessionCapacityController.text = model.capacity.toString();
    _fetchMembersOfSession(main: model.mainMembers, waiting: model.waitingMembers);
  }

  late final SessionModel model;

  final formKey = GlobalKey<FormState>();
  bool readOnly;

  final TextEditingController sessionCapacityController = TextEditingController();
  List<MemberModel>? mainMembers;
  List<MemberModel>? waitingMembers;

  ///MemberModelin sadece _id değeri olduğu için bu değere göre veritabanından tam membermodel verisi çekilecek
  void _fetchMembersOfSession({required List<MemberModel> main, required List<MemberModel> waiting}) async {
    List<MemberModel> fetchedMain = [];
    List<MemberModel> fetchedWaiting = [];

    for (var element in main) {
      BaseResponseModel<MemberModel> res = await APIService<MemberModel>(url: APIS.api.memberId(memberId: element.id))
          .get(fromJsonT: (json) => MemberModel.fromJson(json: json))
          .onError((error, stackTrace) {
        debugPrint(error.toString());
        return BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu");
      });
      if (res.success) fetchedMain.add(res.data!);
    }
    for (var element in waiting) {
      BaseResponseModel<MemberModel> res = await APIService<MemberModel>(url: APIS.api.memberId(memberId: element.id))
          .get(fromJsonT: (json) => MemberModel.fromJson(json: json))
          .onError((error, stackTrace) {
        debugPrint(error.toString());
        return BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu");
      });
      if (res.success) fetchedWaiting.add(res.data!);
    }
    mainMembers = fetchedMain;
    waitingMembers = fetchedWaiting;

    notifyListeners();
  }

  void createParticipantsList() async {
    BaseResponseModel<ListWrapped<SubscriptionModel>> res =
        await APIService<ListWrapped<SubscriptionModel>>(url: APIS.api.subscription(sportType: SportTypes.Yuzme))
            .get(
                fromJsonT: (json) => ListWrapped.fromJson(
                      jsonList: json,
                      fromJsonT: (p0) => SubscriptionModel.fromJson(json: p0),
                    ))
            .onError((error, stackTrace) => BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu"));

    if (res.success) {
      mainMembers = [];
      waitingMembers = [];

      List<SubscriptionModel> listSubs = (res.data?.items) ?? [];
      int capacity = ((int.tryParse(sessionCapacityController.text)) ?? 0) > listSubs.length
          ? listSubs.length
          : ((int.tryParse(sessionCapacityController.text)) ?? 0);
      mainMembers?.addAll(listSubs.map((e) => e.member).toList().getRange(0, capacity));
      waitingMembers?.addAll(listSubs.map((e) => e.member).toList().getRange(capacity, listSubs.length));
    } else {
      CustomRouter.instance.pushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
          ),
          pageConfig: ConfigPopupInfo());
    }
    notifyListeners();
  }

  void onSave() async {
    if (formKey.currentState!.validate()) {
      if (await CustomRouter.instance.waitForResult(
          child:
              const PageAlertDialog(title: "Uyarı", informationText: "Girdiğiniz bilgilere göre seans kaydı oluşturulacaktır. Onaylıyor musunuz ?"),
          pageConfig: ConfigAlertDialog)) {
        SessionModel model = SessionModel(
            dayIndex: 0,
            activityIndex: 0,
            capacity: int.tryParse(sessionCapacityController.text)!,
            mainMembers: mainMembers ?? [],
            waitingMembers: waitingMembers ?? []);

        BaseResponseModel res = await APIService<SessionModel>(url: APIS.api.session())
            .post(model)
            .onError((error, stackTrace) => BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu"));

        if (res.success) {
          ViewModelHome.instance.fetchSession();

          CustomRouter.instance.replacePushWidget(
              child: PagePopupInfo(
                title: "Bildirim",
                informationText: res.message.toString(),
                afterDelay: () => CustomRouter.instance.pop(),
              ),
              pageConfig: ConfigPopupInfo());
        } else {
          CustomRouter.instance
              .pushWidget(child: PagePopupInfo(title: "Bildirim", informationText: res.message.toString()), pageConfig: ConfigPopupInfo());
        }
      }
    }
  }

  void delete() async {
    BaseResponseModel res = await APIService(url: APIS.api.session()).delete(model);
  }
}

/*
import 'package:flutter/material.dart';
import 'package:silivri_havuz/view_model/table.dart';

import '../../model/subscription_model.dart';
import '../../model/trainer_model.dart';
import '../../utils/enums.dart';
import '../model/member_model.dart';
import '../model/session_model.dart';
import '../model/table_model.dart';
import '../navigator/custom_navigation_view.dart';
import '../navigator/ui_page.dart';
import '../network/api.dart';
import '../pages/alert_dialog.dart';
import '../pages/info_popup.dart';
import '../utils/extension.dart';
import '../view_model/home.dart';

class ViewModelSessionDetails extends ChangeNotifier {
  ViewModelSessionDetails({this.readOnly = false}) {
    fetchTrainers();
  }
  ViewModelSessionDetails.fromModel({this.readOnly = true, required this.model}) {
    sessionPickedSportType.text = model.sportType.toString();
    selectedTrainer = model.trainer;

    _dateTimeStart = model.dateTimeStart;
    sessionPickedDate.text = dateFormat.format(model.dateTimeStart);
    sessionPickedTimeStart.text = "${model.dateTimeStart.hour}:${model.dateTimeStart.minute}";

    _dateTimeEnd = model!.dateTimeEnd;
    sessionPickedTimeEnd.text = "${model.dateTimeEnd.hour}:${model.dateTimeEnd.minute}";

    sessionCapacityController.text = model.capacity.toString();
    _fetchMembersOfSession(main: model.mainMembers, waiting: model.waitingMembers);
  }

  late final SessionModel model;

  final formKey = GlobalKey<FormState>();
  bool readOnly;
  DateTime _dateTimeStart = DateTime.now();
  DateTime _dateTimeEnd = DateTime.now();

  TrainerModel? selectedTrainer;
  List<TrainerModel>? listTrainer;

  final TextEditingController sessionPickedDate = TextEditingController();
  final TextEditingController sessionPickedTimeStart = TextEditingController();
  final TextEditingController sessionPickedTimeEnd = TextEditingController();
  final TextEditingController sessionPickedSportType = TextEditingController(text: SportTypes.Yuzme.toString());
  final TextEditingController sessionCapacityController = TextEditingController();
  List<MemberModel>? mainMembers;
  List<MemberModel>? waitingMembers;

  void pickDate(BuildContext context) async {
    final month = DateTime.now().month + 2;
    final DateTime lastDay = DateTime(DateTime.now().year, DateTime.now().month + 2);
    _dateTimeStart = await selectDate(context,
        initialDate: sessionPickedDate.text != "" ? dateFormat.parse(sessionPickedDate.text) : null,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year, DateTime.now().month + 2));
    sessionPickedDate.text = dateFormat.format(_dateTimeStart);
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

  ///MemberModelin sadece _id değeri olduğu için bu değere göre veritabanından tam membermodel verisi çekilecek
  void _fetchMembersOfSession({required List<MemberModel> main, required List<MemberModel> waiting}) async {
    List<MemberModel> fetchedMain = [];
    List<MemberModel> fetchedWaiting = [];

    for (var element in main) {
      BaseResponseModel<MemberModel> res = await APIService<MemberModel>(url: APIS.api.memberId(memberId: element.id))
          .get(fromJsonT: (json) => MemberModel.fromJson(json: json))
          .onError((error, stackTrace) {
        debugPrint(error.toString());
        return BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu");
      });
      if (res.success) fetchedMain.add(res.data!);
    }
    for (var element in waiting) {
      BaseResponseModel<MemberModel> res = await APIService<MemberModel>(url: APIS.api.memberId(memberId: element.id))
          .get(fromJsonT: (json) => MemberModel.fromJson(json: json))
          .onError((error, stackTrace) {
        debugPrint(error.toString());
        return BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu");
      });
      if (res.success) fetchedWaiting.add(res.data!);
    }
    mainMembers = fetchedMain;
    waitingMembers = fetchedWaiting;

    notifyListeners();
  }

  void createParticipantsList() async {
    BaseResponseModel<ListWrapped<SubscriptionModel>> res = await APIService<ListWrapped<SubscriptionModel>>(
            url: APIS.api.subscription(sportType: SportTypes.fromString(sessionPickedSportType.text.trim())))
        .get(
            fromJsonT: (json) => ListWrapped.fromJson(
                  jsonList: json,
                  fromJsonT: (p0) => SubscriptionModel.fromJson(json: p0),
                ))
        .onError((error, stackTrace) => BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu"));

    if (res.success) {
      mainMembers = [];
      waitingMembers = [];

      List<SubscriptionModel> listSubs = (res.data?.items) ?? [];
      int capacity = ((int.tryParse(sessionCapacityController.text)) ?? 0) > listSubs.length
          ? listSubs.length
          : ((int.tryParse(sessionCapacityController.text)) ?? 0);
      mainMembers?.addAll(listSubs.map((e) => e.member).toList().getRange(0, capacity));
      waitingMembers?.addAll(listSubs.map((e) => e.member).toList().getRange(capacity, listSubs.length));
    } else {
      CustomRouter.instance.pushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
          ),
          pageConfig: ConfigPopupInfo());
    }
    notifyListeners();
  }

  void fetchTrainers() async {
    BaseResponseModel<ListWrapped<TrainerModel>> res = await APIService<ListWrapped<TrainerModel>>(url: APIS.api.trainer())
        .get(
            fromJsonT: (json) => ListWrapped.fromJson(
                  jsonList: json,
                  fromJsonT: (p0) => TrainerModel.fromJson(json: p0),
                ))
        .onError((error, stackTrace) => BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu"));

    if (res.success) {
      listTrainer = res.data?.items ?? [];
    } else {
      debugPrint(res.message);
      CustomRouter.instance.pushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
          ),
          pageConfig: ConfigPopupInfo());
    }
    notifyListeners();
  }

  void onSave() async {
    if (formKey.currentState!.validate() && sessionPickedDate.text.isNotEmpty && selectedTrainer != null) {
      if (await CustomRouter.instance.waitForResult(
          child:
              const PageAlertDialog(title: "Uyarı", informationText: "Girdiğiniz bilgilere göre seans kaydı oluşturulacaktır. Onaylıyor musunuz ?"),
          pageConfig: ConfigAlertDialog)) {
        SessionModel model = SessionModel(
            sportType: SportTypes.fromString(sessionPickedSportType.text),
            trainer: selectedTrainer!,
            dateTimeStart: _dateTimeStart,
            dateTimeEnd: _dateTimeEnd,
            capacity: int.tryParse(sessionCapacityController.text)!,
            mainMembers: mainMembers ?? [],
            waitingMembers: waitingMembers ?? []);

        BaseResponseModel res = await APIService<SessionModel>(url: APIS.api.session())
            .post(model)
            .onError((error, stackTrace) => BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu"));

        if (res.success) {
          ViewModelHome.instance.fetchSession();

          CustomRouter.instance.replacePushWidget(
              child: PagePopupInfo(
                title: "Bildirim",
                informationText: res.message.toString(),
                afterDelay: () => CustomRouter.instance.pop(),
              ),
              pageConfig: ConfigPopupInfo());
        } else {
          CustomRouter.instance
              .pushWidget(child: PagePopupInfo(title: "Bildirim", informationText: res.message.toString()), pageConfig: ConfigPopupInfo());
        }
      }
    }
  }

  void delete() async {
    BaseResponseModel res = await APIService(url: APIS.api.session()).delete(model);
  }
}

 */
