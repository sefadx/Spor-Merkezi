import 'dart:async';

import 'package:flutter/material.dart';

import '/model/subscription_model.dart';
import '/model/table_model.dart';
import '/pages/subscription/subscription.dart';
import '/view_model/table.dart';
import '../model/home_screen_model.dart';
import '../model/member_model.dart';
import '../navigator/custom_navigation_view.dart';
import '../navigator/ui_page.dart';
import '../network/api.dart';
import '../pages/info_popup.dart';
import '../pages/member/members.dart';
import '../pages/session/sessions.dart';
import '../utils/enums.dart';

class ViewModelHome extends ChangeNotifier {
  //içeride oluşturulmuş nesneyi dışarıdan çağırmak için
  static ViewModelHome get instance => _start;
  //içeride oluşturulmuş nesneyi kullanabilmek için
  static final ViewModelHome _start = ViewModelHome._instance();
  //dışarıdan sınıftan nesne oluşturmaya izin vermeden içeride gizli constructor methodu
  ViewModelHome._instance() {
    fetchWeeks();
    fetchMember();
    fetchSubscriptions();
    fetchWeekDefault();
    weekScrollController.addListener(() {
      if (weekScrollController.offset >=
              weekScrollController.position.maxScrollExtent * 1.00 &&
          !weekScrollController.position.outOfRange) {
        fetchWeeks(search: weekSearchTextEditingController.text);
      }
    });
    memberScrollController.addListener(() {
      if (memberScrollController.offset >=
              memberScrollController.position.maxScrollExtent * 1.00 &&
          !memberScrollController.position.outOfRange) {
        fetchMember(search: memberSearchTextEditingController.text);
      }
    });
    subscriptionScrollController.addListener(() {
      if (subscriptionScrollController.offset >=
              subscriptionScrollController.position.maxScrollExtent * 1.00 &&
          !subscriptionScrollController.position.outOfRange) {
        fetchSubscriptions(
            search: subscriptionSearchTextEditingController.text);
      }
    });
  }

  String tc = "";
  late WeekModel weekDefault;

  List<HomeScreenModel> screenList = [
    HomeScreenModel(
        title: "Seans Yönetimi", icon: Icons.schedule, body: PageSessions()),
    HomeScreenModel(
        title: "Üye Yönetimi", icon: Icons.people, body: const PageMembers()),
    HomeScreenModel(
        title: "Abonelik Yönetimi",
        icon: Icons.card_membership,
        body: PageSubscription()),
  ];

  int _index = 0;
  int get screenIndex => _index;

  set setScreenIndex(int index) {
    _index = index;
    notifyListeners();
  }

  final StreamController<List<WeekModel>> weeks = StreamController();
  final TextEditingController weekSearchTextEditingController =
      TextEditingController();
  final ScrollController weekScrollController = ScrollController();
  int _currentPageWeek = 1;
  bool _isFetchingWeek = false;
  bool _hasMoreDataWeek = true;
  final List<WeekModel> _allWeeks = [];

  final StreamController<List<MemberModel>> members = StreamController();
  final TextEditingController memberSearchTextEditingController =
      TextEditingController();
  final ScrollController memberScrollController = ScrollController();
  int _currentPageMember = 1;
  bool _isFetchingMember = false;
  bool _hasMoreDataMember = true;
  final List<MemberModel> _allMembers = [];

  final StreamController<List<SubscriptionModel>> subscriptions =
      StreamController();
  final TextEditingController subscriptionSearchTextEditingController =
      TextEditingController();
  final ScrollController subscriptionScrollController = ScrollController();
  int _currentPageSubscription = 1;
  bool _isFetchingSubscription = false;
  bool _hasMoreDataSubscription = true;
  List<SubscriptionModel> _allSubscriptions = [];

  Future<void> resetAndFetchMemberModel({String? search}) async {
    _currentPageMember = 1;
    _hasMoreDataMember = true;
    _allMembers.clear(); // Liste temizlenir
    members.sink.add([]); // UI hemen sıfırlanır
    //if (search == null) memberSearchTextEditingController.clear();
    await fetchMember(search: search);
  }

  Future<void> fetchMember({int limit = 10, String? search}) async {
    if (_isFetchingMember || !_hasMoreDataMember) return;
    _isFetchingMember = true;
    if (search == null) memberSearchTextEditingController.clear();

    BaseResponseModel<ListWrapped<MemberModel>> res =
        await APIService<ListWrapped<MemberModel>>(
                url: APIS.api.member(
                    limit: limit, page: _currentPageMember, search: search))
            .get(
                fromJsonT: (json) => ListWrapped.fromJson(
                      jsonList: json,
                      fromJsonT: (p0) => MemberModel.fromJson(json: p0),
                    ))
            .onError((error, stackTrace) => BaseResponseModel(
                success: false, message: "Bilinmeyen bir hata oluştu"));

    if (res.success) {
      List<MemberModel> newMember = (res.data?.items) ?? [];

      if (newMember.isEmpty || newMember.length < limit) {
        _hasMoreDataMember = false; // Daha fazla veri yoksa flag'i kapat
      }
      _allMembers.addAll(newMember);
      members.sink.add(_allMembers);
      _currentPageMember++;
      debugPrint("apiden gelen yanıt: ${res.toJson()}");
      /*CustomRouter.instance.replacePushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
            afterDelay: () => CustomRouter.instance.pop(),
          ),
          pageConfig: ConfigPopupInfo());*/
    } else {
      members.addError(res);
      CustomRouter.instance.pushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
          ),
          pageConfig: ConfigPopupInfo());
    }
    _isFetchingMember = false;
  }

  Future<void> resetAndFetchWeek({String? search}) async {
    _currentPageWeek = 1;
    _hasMoreDataWeek = true;
    _allWeeks.clear(); // Liste temizlenir
    weeks.sink.add([]); // UI hemen sıfırlanır
    //if (search == null) memberSearchTextEditingController.clear();
    await fetchWeeks(search: search);
  }

  Future<void> fetchWeeks({int limit = 10, String? search}) async {
    if (_isFetchingWeek || !_hasMoreDataWeek) return;
    _isFetchingWeek = true;
    if (search == null) weekSearchTextEditingController.clear();

    BaseResponseModel<ListWrapped<WeekModel>> res =
        await APIService<ListWrapped<WeekModel>>(
                url: APIS.api.week(page: _currentPageWeek, limit: limit))
            .get(
                fromJsonT: (json) => ListWrapped.fromJson(
                      jsonList: json,
                      fromJsonT: (p0) => WeekModel.fromJson(json: p0),
                    ))
            .onError((error, stackTrace) => BaseResponseModel(
                success: false, message: "Bilinmeyen bir hata oluştu"));

    if (res.success) {
      List<WeekModel> newWeek = (res.data?.items) ?? [];
      if (newWeek.isEmpty || newWeek.length < limit) {
        _hasMoreDataWeek = false; // Daha fazla veri yoksa flag'i kapat
      }
      _allWeeks.addAll(newWeek);
      weeks.sink.add(_allWeeks);
      _currentPageWeek++;
      debugPrint("apiden gelen yanıt: ${res.toJson()}");
      /*CustomRouter.instance.replacePushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
            afterDelay: () => CustomRouter.instance.pop(),
          ),
          pageConfig: ConfigPopupInfo());*/
    } else {
      weeks.addError(res);
      CustomRouter.instance.pushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
          ),
          pageConfig: ConfigPopupInfo());
    }
    _isFetchingWeek = false;
  }

  Future<void> resetAndFetchSubscription({String? search}) async {
    _currentPageSubscription = 1;
    _hasMoreDataSubscription = true;
    _allSubscriptions.clear(); // Liste temizlenir
    subscriptions.sink.add([]); // UI hemen sıfırlanır
    //if (search == null) memberSearchTextEditingController.clear();
    await fetchSubscriptions(search: search);
  }

  Future<void> fetchSubscriptions({int limit = 10, String? search}) async {
    if (_isFetchingSubscription || !_hasMoreDataSubscription) return;
    _isFetchingSubscription = true;
    if (search == null) subscriptionSearchTextEditingController.clear();

    BaseResponseModel<ListWrapped<SubscriptionModel>> res =
        await APIService<ListWrapped<SubscriptionModel>>(
                url: APIS.api.subscription(
                    page: _currentPageSubscription,
                    limit: limit,
                    search: search))
            .get(
                fromJsonT: (json) => ListWrapped.fromJson(
                      jsonList: json,
                      fromJsonT: (p0) => SubscriptionModel.fromJson(json: p0),
                    ))
            .onError((error, stackTrace) => BaseResponseModel(
                success: false, message: "Bilinmeyen bir hata oluştu"));

    if (res.success) {
      List<SubscriptionModel> newSubscription = (res.data?.items) ?? [];
      if (newSubscription.isEmpty || newSubscription.length < limit) {
        _hasMoreDataSubscription = false; // Daha fazla veri yoksa flag'i kapat
      }
      _allSubscriptions.addAll(newSubscription);
      subscriptions.sink.add(_allSubscriptions);
      _currentPageSubscription++;
      debugPrint("apiden gelen yanıt: ${res.toJson()}");
      /*CustomRouter.instance.replacePushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
            afterDelay: () => CustomRouter.instance.pop(),
          ),
          pageConfig: ConfigPopupInfo());*/
    } else {
      subscriptions.addError(res);
      CustomRouter.instance.pushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
          ),
          pageConfig: ConfigPopupInfo());
    }
    _isFetchingSubscription = false;
  }

  Future<void> fetchSearchSubscription({required String tcKimlik}) async {
    try {
      _allSubscriptions.clear();
      BaseResponseModel<ListWrapped<MemberModel>> resMember =
          await APIService<ListWrapped<MemberModel>>(
                  url: APIS.api.member(limit: 1, page: 1, search: tcKimlik))
              .get(
                  fromJsonT: (json) => ListWrapped.fromJson(
                        jsonList: json,
                        fromJsonT: (p0) => MemberModel.fromJson(json: p0),
                      ))
              .onError((error, stackTrace) => BaseResponseModel(
                  success: false, message: "Bilinmeyen bir hata oluştu"));

      if (resMember.success && resMember.data!.items.isNotEmpty) {
        MemberModel member = resMember.data!.items.first;
        //CustomRouter.instance.pushWidget(child: PagePopupInfo(title: "Bildirim", informationText: res.message.toString()), pageConfig: ConfigPopupInfo());
        BaseResponseModel<ListWrapped<SubscriptionModel>> res =
            await APIService<ListWrapped<SubscriptionModel>>(
                    url: APIS.api.subscriptionId(memberId: member.id))
                .get(
                    fromJsonT: (json) => ListWrapped.fromJson(
                          jsonList: json,
                          fromJsonT: (p0) =>
                              SubscriptionModel.fromJson(json: p0),
                        ))
                .onError((error, stackTrace) => BaseResponseModel(
                    success: false, message: "Bilinmeyen bir hata oluştu"));

        if (res.success) {
          List<SubscriptionModel> newSubscription = (res.data?.items) ?? [];
          _allSubscriptions.addAll(newSubscription);
          subscriptions.sink.add(_allSubscriptions);
          debugPrint("apiden gelen yanıt: ${res.toJson()}");
          /*CustomRouter.instance.replacePushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
            afterDelay: () => CustomRouter.instance.pop(),
          ),
          pageConfig: ConfigPopupInfo());*/
        } else {
          subscriptions.addError(res);
          CustomRouter.instance.pushWidget(
              child: PagePopupInfo(
                title: "Bildirim",
                informationText: res.message.toString(),
              ),
              pageConfig: ConfigPopupInfo());
        }
      } else {
        CustomRouter.instance.pushWidget(
            child: PagePopupInfo(
                title: "Bildirim", informationText: "Üye kaydı bulunamadı."),
            pageConfig: ConfigPopupInfo());
      }
    } catch (err) {
      CustomRouter.instance.pushWidget(
          child: const PagePopupInfo(
              title: "Bildirim",
              informationText:
                  "Subscription from memberId : Teknik Ekiple İletişime geçin."),
          pageConfig: ConfigPopupInfo());
      rethrow;
    }
  }

  Future<void> fetchWeekDefault() async {
    weekDefault = await ViewModelTable.fetchWeekDefault() ?? weekEmpty;
  }

  final WeekModel weekEmpty = WeekModel(
      daysOff: [],
      initialDayOfWeek: DateTime(2020),
      days: [
        Day(name: "Pazartesi", day: 1, activities: [
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty)
        ]),
        Day(name: "Salı", day: 2, activities: [
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty)
        ]),
        Day(name: "Çarşamba", day: 3, activities: [
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty)
        ]),
        Day(name: "Perşembe", day: 4, activities: [
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty)
        ]),
        Day(name: "Cuma", day: 5, activities: [
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty)
        ]),
        Day(name: "Cumartesi", day: 6, activities: [
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty)
        ]),
        Day(name: "Pazar", day: 7, activities: [
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty),
          null,
          Activity(
              type: ActivityType.empty,
              ageGroup: AgeGroup.empty,
              fee: FeeType.empty)
        ]),
      ]);
}

/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silivri_havuz/model/table_model.dart';

import '../model/home_screen_model.dart';
import '../model/member_model.dart';
import '../model/session_model.dart';
import '../navigator/custom_navigation_view.dart';
import '../navigator/ui_page.dart';
import '../network/api.dart';
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
    fetchTableModel();
    fetchMember();
    weekScrollController.addListener(() {
      if (weekScrollController.position.pixels >= weekScrollController.position.maxScrollExtent - 100) {}
    });
    memberScrollController.addListener(() {
      if (weekScrollController.position.pixels >= weekScrollController.position.maxScrollExtent - 100) {}
    });
  }

  List<HomeScreenModel> screenList = [
    HomeScreenModel(title: "Seans Yönetimi", icon: Icons.schedule, body: PageSessions()),
    HomeScreenModel(title: "Üye Yönetimi", icon: Icons.people, body: PageMembers()),
    //HomeScreenModel(title: "Abonelik", icon: Icons.attach_money, body: PageReportIncome()),
    //HomeScreenModel(title: "Bildirimler", icon: Icons.notifications, body: SizedBox())
  ];

  int _index = 0;
  int get screenIndex => _index;

  set setScreenIndex(int index) {
    _index = index;
    notifyListeners();
  }

  final StreamController<List<WeekModel>> tableModels = StreamController();
  final TextEditingController weekSearchTextEditingController = TextEditingController();
  final ScrollController weekScrollController = ScrollController();

  final StreamController<List<MemberModel>> members = StreamController();
  final TextEditingController memberSearchTextEditingController = TextEditingController();
  final ScrollController memberScrollController = ScrollController();

  fetchMember({int page = 1, int limit = 100, String? search}) async {
    search == null ? memberSearchTextEditingController.clear() : null;
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
      debugPrint("apiden gelen yanıt: ${res.toJson()}");
      /*CustomRouter.instance.replacePushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
            afterDelay: () => CustomRouter.instance.pop(),
          ),
          pageConfig: ConfigPopupInfo());*/
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

  fetchTableModel({int page = 1, int limit = 100, String? search}) async {
    search == null ? weekSearchTextEditingController.clear() : null;
    BaseResponseModel<ListWrapped<WeekModel>> res = await APIService<ListWrapped<WeekModel>>(url: APIS.api.session(page: page, limit: limit))
        .get(
            fromJsonT: (json) => ListWrapped.fromJson(
                  jsonList: json,
                  fromJsonT: (p0) => WeekModel.fromJson(json: p0),
                ))
        .onError((error, stackTrace) => BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu"));

    if (res.success) {
      List<WeekModel> listSession = (res.data?.items) ?? [];
      tableModels.sink.add(listSession);
      debugPrint("apiden gelen yanıt: ${res.toJson()}");
      /*CustomRouter.instance.replacePushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
            afterDelay: () => CustomRouter.instance.pop(),
          ),
          pageConfig: ConfigPopupInfo());*/
    } else {
      tableModels.addError(res);
      CustomRouter.instance.pushWidget(
          child: PagePopupInfo(
            title: "Bildirim",
            informationText: res.message.toString(),
          ),
          pageConfig: ConfigPopupInfo());
    }
  }
}

 */
