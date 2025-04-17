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

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name.toString(),
      'day': day,
      'activities': activities.map((e) => e!.toJson()).toList(),
    };
  }
}

class Week implements JsonProtocol {
  final List<Day> days;

  Week({required this.days});

  @override
  Map<String, dynamic> toJson() {
    return {
      'days': days.map(
        (e) => e.toJson(),
      )
    };
  }
}

class TableModel {
  TableModel();
  late DateTime _createdAt;
  DateTime get createdAt => _createdAt;

  late String _id;
  String get id => _id;

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
  final Week week = Week(days: [
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
      TableModel model = TableModel();
      model._id = json["_id"];
      model._createdAt = DateTime.parse(json['createdAt']).toLocal();
      return model;
    } catch (err) {
      if (err.toString() == "type 'List<dynamic>' is not a subtype of type 'List<MemberModel>'") {
        SessionModel model = SessionModel(
          dayIndex: 0,
          activityIndex: 0,
          mainMembers: List<MemberModel>.from((json["mainMembers"] as List).map(
            (e) => MemberModel.id(id: e.toString()),
          )),
          waitingMembers: List<MemberModel>.from((json["waitingMembers"] as List).map(
            (e) => MemberModel.id(id: e.toString()),
          )),
          capacity: json["capacity"],
        );
        model._id = json["_id"];
        model._createdAt = DateTime.parse(json['createdAt']).toLocal();
        return model;
      } else {
        debugPrint(err.toString());
        rethrow;
      }
    }
  }
}
