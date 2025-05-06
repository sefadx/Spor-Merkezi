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
    return "${initialDayOfWeek.year} - ${_getWeekNumber(initialDayOfWeek)}. Hafta (${monday.day} ${_getMonthName(monday.month)} - ${sunday.day} ${_getMonthName(sunday.month)})";
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
