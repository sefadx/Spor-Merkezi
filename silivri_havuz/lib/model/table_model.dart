import 'package:flutter/material.dart';

import '/model/session_model.dart';
import '../network/api.dart';
import '../utils/enums.dart';

class TimeSlot {
  final String start;
  final String end;
  final bool isBreak;

  TimeSlot({required this.start, required this.end, required this.isBreak});
}

class Activity implements JsonProtocol {
  SessionModel? sessionModel;
  ActivityType type; // e.g., "Yetişkin Kadın", "Yüzme Akademi"
  AgeGroup ageGroup; // e.g., "13+", "6-12"
  FeeType fee; // e.g., "40 TL", "Ücretsiz"

  Activity({this.sessionModel, required this.type, required this.ageGroup, required this.fee});
  factory Activity.fromJson({required Map<String, dynamic> json}) {
    try {
      //debugPrint("activity json veri" + json.toString());
      return Activity(
          sessionModel: json["sessionModel"] != null ? SessionModel.fromJson(json: json["sessionModel"]) : null,
          type: ActivityType.fromString(json["type"]),
          ageGroup: AgeGroup.fromString(json["ageGroup"]),
          fee: FeeType.fromString(json["fee"]));
    } catch (err) {
      debugPrint("Activity fromJson: $err");
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionModel': sessionModel?.toJson(),
      'type': type.toString(),
      'ageGroup': ageGroup.toString(),
      'fee': fee.toString(),
    };
  }
}

class Day implements JsonProtocol {
  String name;
  final int day; // e.g., "Salı", "Çarşamba"
  final List<Activity?> activities; // Matches timeSlots length, null for breaks or no activity

  Day({required this.name, required this.day, required this.activities});
  factory Day.fromJson({required Map<String, dynamic> json}) {
    try {
      return Day(
        day: json["day"],
        name: json["name"],
        activities: List<Activity?>.of(
          (json["activities"] as List).map((e) => e != null ? Activity.fromJson(json: e) : null),
        ),
      );
    } catch (err) {
      debugPrint("Day fromJson: $err");
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name.toString(),
      'day': day,
      'activities': activities.map((e) => e?.toJson()).toList(),
    };
  }
}

class WeekModel implements JsonProtocol {
  List<int> daysOff;

  final DateTime initialDayOfWeek;
  String get name => "${initialDayOfWeek.day}/${initialDayOfWeek.month}/${initialDayOfWeek.year}";
  String getWeekRangeTitle() {
    DateTime monday = initialDayOfWeek.subtract(Duration(days: initialDayOfWeek.weekday - 1));
    DateTime sunday = monday.add(const Duration(days: 6));

    String formatDate(DateTime d) => "${d.day} ${_getMonthName(d.month)} ${d.year}";
    return "${initialDayOfWeek.year} - ${_getWeekNumber(initialDayOfWeek)}. Hafta (${monday.day} ${_getMonthName(initialDayOfWeek.month)} - ${sunday.day} ${_getMonthName(initialDayOfWeek.month)})";
  }

  String _getMonthName(int month) {
    const months = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"];
    return months[month - 1];
  }

  int _getWeekNumber(DateTime date) {
    // Haftanın ilk günü Pazartesi olarak ayarlandı
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - DateTime.monday;

    final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
    final difference = date.difference(firstMonday).inDays;

    return ((difference) / 7).ceil();
  }

  final List<Day> days;

  late DateTime _createdAt;
  DateTime get createdAt => _createdAt;

  late String _id;
  String get id => _id;

  WeekModel({required this.daysOff, required this.initialDayOfWeek, required this.days});

  factory WeekModel.fromJson({required Map<String, dynamic> json}) {
    try {
      WeekModel model = WeekModel(
        daysOff: List<int>.from(json["daysOff"]),
        initialDayOfWeek: DateTime.parse(json['initialDayOfWeek']).toLocal(),
        days: List<Day>.of((json["days"] as List).map((e) => Day.fromJson(json: e))),
      );
      model._id = json["_id"];
      model._createdAt = DateTime.parse(json['createdAt']).toLocal();
      return model;
    } catch (err) {
      debugPrint("WeekModel fromJson: $err");
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'daysOff': daysOff,
      'initialDayOfWeek': initialDayOfWeek.toUtc().toIso8601String(),
      'days': days.map((e) => e.toJson()).toList(),
    };
  }
}
/*
class TableModel extends JsonProtocol {
  TableModel({this.initialDayOfWeek});
  TableModel.fromWeek({required this.week, required this.initialDayOfWeek});

  late DateTime _createdAt;
  DateTime get createdAt => _createdAt;

  late String _id;
  String get id => _id;

  DateTime? initialDayOfWeek;

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

  //null => seansarası
  //activity => seanslar
  WeekModel week = WeekModel(initialDayOfWeek: DateTime(2020), days: [
    Day(name: "Pazartesi", day: 1, activities: [
      Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
      null,
      Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
      null,
      Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
      null,
      Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
      null,
      Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
      null,
      Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
      null,
      Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
      null,
      Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty),
      null,
      Activity(type: ActivityType.empty, ageGroup: AgeGroup.empty, fee: FeeType.empty)
    ]),
    Day(name: "Salı", day: 2, activities: [
      Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
      null,
      Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
      null,
      Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
      null,
      Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.free),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid)
    ]),
    Day(name: "Çarşamba", day: 3, activities: [
      Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
      null,
      Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
      null,
      Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
      null,
      Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.free),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid)
    ]),
    Day(name: "Perşembe", day: 4, activities: [
      Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
      null,
      Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
      null,
      Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
      null,
      Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.free),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid)
    ]),
    Day(name: "Cuma", day: 5, activities: [
      Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
      null,
      Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
      null,
      Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
      null,
      Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.free),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid)
    ]),
    Day(name: "Cumartesi", day: 6, activities: [
      Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.havuzBakim, ageGroup: AgeGroup.all, fee: FeeType.free)
    ]),
    Day(name: "Pazar", day: 7, activities: [
      Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
      null,
      Activity(type: ActivityType.havuzBakim, ageGroup: AgeGroup.all, fee: FeeType.free)
    ]),
  ]);

  factory TableModel.fromJson({required Map<String, dynamic> json}) {
    try {
      TableModel model = TableModel.fromWeek(
        week: WeekModel.fromJson(json: json["week"]),
        initialDayOfWeek: DateTime.parse(json['initialDateOfWeek']).toLocal(),
      );
      model._id = json["_id"];
      model._createdAt = DateTime.parse(json['createdAt']).toLocal();
      return model;
    } catch (err) {
      debugPrint("TableModel fromJson: $err");
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {"week": week.toJson()};
  }
}
*/
