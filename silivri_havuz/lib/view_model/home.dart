import 'package:flutter/material.dart';
import '../model/health_status.dart';
import '../model/payment_status.dart';
import '../network/api.dart';
import '../model/home_screen_model.dart';
import '../model/member_model.dart';
import '../model/session_model.dart';
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
    fetchMember();
  }

  List<HomeScreenModel> screenList = [
    HomeScreenModel(title: "Seans Yönetimi", icon: Icons.schedule, body: PageSessions()),
    HomeScreenModel(title: "Üye Yönetimi", icon: Icons.people, body: PageMembers()),
    HomeScreenModel(title: "Gelir Raporları", icon: Icons.attach_money, body: PageReportIncome()),
    HomeScreenModel(title: "Bildirimler", icon: Icons.notifications, body: SizedBox())
  ];

  final ValueNotifier<int> _index = ValueNotifier(0);
  ValueNotifier<int> get screenIndex => _index;

  set setScreenIndex(int index) {
    _index.value = index;
    _index.notifyListeners();
  }

  int get getScreenIndex {
    return _index.value;
  }

  final ValueNotifier<List<SessionModel>> sessions = ValueNotifier([]);
  final TextEditingController sessionSearchTextEditingController = TextEditingController();

  final ValueNotifier<List<MemberModel>> members = ValueNotifier([]);
  final TextEditingController memberSearchTextEditingController = TextEditingController();

  void fetchMember({int page = 1, int limit = 1000, String search = ""}) async {
    members.value.clear();
    BaseResponseModel res = await APIService(url: APIS.api.member(limit: limit, page: page, search: search))
        .getBaseResponseModel()
        .onError((error, stackTrace) => BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu"));
    for (var element in ((res.data) as List)) {
      members.value.add(MemberModel.fromJson(json: element));
    }
    members.notifyListeners();
  }

  void fetchSession({int page = 1, int limit = 100}) async {
    sessions.value.clear();
    BaseResponseModel res = await APIService(url: APIS.api.session(page: page, limit: limit))
        .getBaseResponseModel()
        .onError((error, stackTrace) => BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu"));
    for (var element in ((res.data) as List)) {
      sessions.value.add(SessionModel.fromJson(json: element));
    }
    sessions.notifyListeners();
    debugPrint(res.data.toString());
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
