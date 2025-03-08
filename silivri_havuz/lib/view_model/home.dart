import 'dart:async';
import 'package:flutter/material.dart';
import '../navigator/custom_navigation_view.dart';
import '../navigator/ui_page.dart';
import '../network/api.dart';
import '../model/home_screen_model.dart';
import '../model/member_model.dart';
import '../model/session_model.dart';
import '../pages/info_popup.dart';
import '../pages/member/members.dart';
import '../pages/reports/incomeReports.dart';
import '../pages/session/sessions.dart';

class ViewModelHome extends ChangeNotifier {
  //içeride oluşturulmuş nesneyi dışarıdan çağırmak için
  static ViewModelHome get instance => _start;
  //içeride oluşturulmuş nesneyi kullanabilmek için
  static final ViewModelHome _start = ViewModelHome._instance();
  //dışarıdan sınıftan nesne oluşturmaya izin vermeden içeride gizli constructor methodu
  ViewModelHome._instance() {
    fetchSession();
    fetchMember();
  }

  List<HomeScreenModel> screenList = [
    HomeScreenModel(title: "Seans Yönetimi", icon: Icons.schedule, body: PageSessions()),
    HomeScreenModel(title: "Üye Yönetimi", icon: Icons.people, body: PageMembers()),
    HomeScreenModel(title: "Gelir Raporları", icon: Icons.attach_money, body: PageReportIncome()),
    HomeScreenModel(title: "Bildirimler", icon: Icons.notifications, body: SizedBox())
  ];

  int _index = 0;
  int get screenIndex => _index;

  set setScreenIndex(int index) {
    _index = index;
    notifyListeners();
  }

  final StreamController<List<SessionModel>> sessions = StreamController();
  final TextEditingController sessionSearchTextEditingController = TextEditingController();

  final StreamController<List<MemberModel>> members = StreamController();
  final TextEditingController memberSearchTextEditingController = TextEditingController();

  fetchMember({int page = 1, int limit = 100, String search = ""}) async {
    BaseResponseModel<ListWrapped<MemberModel>> res =
        await APIService<ListWrapped<MemberModel>>(url: APIS.api.member(limit: limit, page: page, search: search))
            .get(
                fromJsonT: (json) => ListWrapped.fromJson(
                      jsonList: json,
                      fromJsonT: (p0) => MemberModel.fromJson(json: p0),
                    ))
            .onError((error, stackTrace) => BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu"));

    if (res.success) {
      List<MemberModel> listMember = (res.data?.items) ?? [];
      members.sink.add(listMember);
      CustomRouter.instance.replacePushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
            afterDelay: () => CustomRouter.instance.pop(),
          ),
          pageConfig: ConfigPopupInfo());
    } else {
      members.addError(res);
      CustomRouter.instance.pushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
          ),
          pageConfig: ConfigPopupInfo());
    }
  }

  fetchSession({int page = 1, int limit = 10}) async {
    BaseResponseModel<ListWrapped<SessionModel>> res = await APIService<ListWrapped<SessionModel>>(url: APIS.api.session(page: page, limit: limit))
        .get(
            fromJsonT: (json) => ListWrapped.fromJson(
                  jsonList: json,
                  fromJsonT: (p0) => SessionModel.fromJson(json: p0),
                ))
        .onError((error, stackTrace) => BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu"));

    if (res.success) {
      List<SessionModel> listSession = (res.data?.items) ?? [];
      sessions.sink.add(listSession);
      CustomRouter.instance.replacePushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
            afterDelay: () => CustomRouter.instance.pop(),
          ),
          pageConfig: ConfigPopupInfo());
    } else {
      sessions.addError(res);
      CustomRouter.instance.pushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
          ),
          pageConfig: ConfigPopupInfo());
    }
  }
/*
  final List<String> listCities = [];
  final List<String> listGenders = [];
  final List<String> listMaritalStatus = [];
  final List<String> listEducationLevels = [];
  final List<String> listProfessions = [];
  final List<String> listHealthStatusCheck = [];
  final List<String> listPaymentStatus = [];

  void fetchVariables() async {
    BaseResponseModel<Map<String, dynamic>> res = await APIService<Map<String, dynamic>>(url: APIS.api.variables()).getBaseResponseModel();
    res.data?.forEach((key, value) {
      switch (key) {
        case "Cities":
          listCities.addAll(List<String>.from(value));
          break;
        case "Genders":
          listGenders.addAll(List<String>.from(value));
          break;
        case "EducationLevels":
          listEducationLevels.addAll(List<String>.from(value));
          break;
        case "HealthStatusCheck":
          listHealthStatusCheck.addAll(List<String>.from(value));
          break;
        case "PaymentStatus":
          listPaymentStatus.addAll(List<String>.from(value));
          break;
        default:
          debugPrint("Bilinmeyen değişken: $key");
      }
    });
    notifyListeners();
  }*/
}
