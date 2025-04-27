import 'package:flutter/material.dart';
import '/view_model/home.dart';
import '../model/session_model.dart';
import '../model/table_model.dart';
import '../navigator/custom_navigation_view.dart';
import '../navigator/ui_page.dart';
import '../network/api.dart';
import '../pages/alert_dialog.dart';
import '../pages/info_popup.dart';

class ViewModelTable extends ChangeNotifier {
  ViewModelTable({required this.week});

  int? selectedDayIndex, selectedActivityIndex;
  //List<int> daysOff = [];
  WeekModel week;
  void updateProvider() => notifyListeners();

  final List<TimeSlot> timeSlots = [
    TimeSlot(start: "08:30", end: "09:30", isBreak: false),
    TimeSlot(start: "09:30", end: "10:00", isBreak: true),
    TimeSlot(start: "10:00", end: "11:00", isBreak: false),
    TimeSlot(start: "11:00", end: "11:30", isBreak: true),
    TimeSlot(start: "11:30", end: "12:30", isBreak: false),
    TimeSlot(start: "12:30", end: "13:00", isBreak: true),
    TimeSlot(start: "13:00", end: "14:00", isBreak: false),
    TimeSlot(start: "14:00", end: "14:30", isBreak: true),
    TimeSlot(start: "14:30", end: "15:30", isBreak: false),
    TimeSlot(start: "15:30", end: "16:00", isBreak: true),
    TimeSlot(start: "16:00", end: "17:00", isBreak: false),
    TimeSlot(start: "17:00", end: "17:30", isBreak: true),
    TimeSlot(start: "17:30", end: "18:30", isBreak: false),
    TimeSlot(start: "18:30", end: "19:00", isBreak: true),
    TimeSlot(start: "19:00", end: "20:00", isBreak: false),
    TimeSlot(start: "20:00", end: "20:30", isBreak: true),
    TimeSlot(start: "20:30", end: "21:30", isBreak: false),
  ];

  void setActivity(Activity type, int dayIndex, int activityIndex) {
    week.days[dayIndex].activities[activityIndex] = type;
    notifyListeners();
  }

  void setDaysOff(int dayIndex) {
    if (getDaysOff(dayIndex)) {
      week.daysOff.removeAt(week.daysOff.indexWhere((e) => e == dayIndex));
    } else {
      week.daysOff.add(dayIndex);
      week.days.elementAt(dayIndex).activities.forEach((e) => e?.sessionModel = null);
      /*for (var e in week.days) {
        if (week.daysOff.indexWhere((dayOff) => dayOff == e.day) != -1) {
          for (var a in e.activities) {
            a?.sessionModel = null;
          }
        }
      }*/
    }

    notifyListeners();
  }

  bool getDaysOff(int dayIndex) => week.daysOff.firstWhere((e) => e == dayIndex, orElse: () => -1) == -1 ? false : true;

  void setSessionModel({required SessionModel? model}) {
    try {
      week.days.elementAt(selectedDayIndex!).activities.elementAt(selectedActivityIndex!)!.sessionModel = model;
      notifyListeners();
    } catch (err) {
      CustomRouter.instance.pushWidget(child: PagePopupInfo(title: "Bildirim", informationText: err.toString()), pageConfig: ConfigPopupInfo());
    }
  }

  Future<void> postWeek() async {
    if (await CustomRouter.instance.waitForResult(
        child: const PageAlertDialog(title: "Uyarı", informationText: "Girdiğiniz bilgilere göre yeni hafta oluşturulacaktır. Onaylıyor musunuz ?"),
        pageConfig: ConfigAlertDialog)) {
      //TableModel model = TableModel();
      WeekModel model = week;

      BaseResponseModel res = await APIService<WeekModel>(url: APIS.api.week()).post(model).onError((error, stackTrace) {
        debugPrint(error.toString());
        return BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu");
      });

      if (res.success) {
        ViewModelHome.instance.fetchWeeks();
        CustomRouter.instance.replacePushWidget(
            child: PagePopupInfo(
              title: "Bildirim",
              informationText: res.message.toString(),
              afterDelay: () => CustomRouter.instance.pop(),
            ),
            pageConfig: ConfigPopupInfo());
        notifyListeners();
      } else {
        CustomRouter.instance
            .pushWidget(child: PagePopupInfo(title: "Bildirim", informationText: res.message.toString()), pageConfig: ConfigPopupInfo());
      }
    }
  }

  Future<void> updateWeek() async {
    if (await CustomRouter.instance.waitForResult(
        child: const PageAlertDialog(title: "Uyarı", informationText: "Hafta düzeni güncellenecektir. Onaylıyor musunuz ?"),
        pageConfig: ConfigAlertDialog)) {
      //TableModel model = TableModel();
      WeekModel model = week;

      BaseResponseModel res = await APIService<WeekModel>(url: APIS.api.weekId(weekId: model.id)).put(model).onError((error, stackTrace) {
        debugPrint(error.toString());
        return BaseResponseModel(success: false, message: "İşlem gerçekleştirilemedi. Bilinmeyen bir hata oluştu.");
      });

      if (res.success) {
        ViewModelHome.instance.fetchWeeks();
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

  static Future<bool> queryWeek({required DateTime date}) async {
    BaseResponseModel<ListWrapped<WeekModel>> res = await APIService<ListWrapped<WeekModel>>(url: APIS.api.week(search: date.toIso8601String()))
        .get(
            fromJsonT: (json) => ListWrapped.fromJson(
                  jsonList: json,
                  fromJsonT: (p0) => WeekModel.fromJson(json: p0),
                ))
        .onError((error, stackTrace) {
      debugPrint(error.toString());
      return BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu");
    });
    if (res.success && res.data!.items.isEmpty) {
      return true;
    } else {
      CustomRouter.instance.pushWidget(
        child: PagePopupInfo(title: "Bildirim", informationText: res.message.toString()),
        pageConfig: ConfigPopupInfo(),
      );
      return false;
    }
  }
}
