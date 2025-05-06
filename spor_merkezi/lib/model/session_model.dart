import 'package:flutter/material.dart';

import '../network/api.dart';
import 'member_model.dart';

class SessionModel implements JsonProtocol {
  SessionModel({
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.capacity,
    required this.mainMembers,
    required this.waitingMembers,
  });
/*
  late DateTime _createdAt;
  DateTime get createdAt => _createdAt;*/

  late String _id;
  String get id => _id;

  final String dateTimeStart;
  final String dateTimeEnd;
  final int capacity;
  List<MemberModel> mainMembers;
  List<MemberModel> waitingMembers;

  factory SessionModel.fromJson({required Map<String, dynamic> json}) {
    try {
      SessionModel model = SessionModel(
        dateTimeStart: json["dateTimeStart"],
        dateTimeEnd: json["dateTimeEnd"],
        mainMembers: json["mainMembers"],
        waitingMembers: json["waitingMembers"],
        capacity: json["capacity"],
      );
      model._id = json["_id"];
      //model._createdAt = DateTime.parse(json['createdAt']).toLocal();
      return model;
    } catch (err) {
      if (err.toString() == "type 'List<dynamic>' is not a subtype of type 'List<MemberModel>'") {
        SessionModel model = SessionModel(
          dateTimeStart: json["dateTimeStart"],
          dateTimeEnd: json["dateTimeEnd"],
          mainMembers: List<MemberModel>.from((json["mainMembers"] as List).map(
            (e) => MemberModel.id(id: e.toString()),
          )),
          waitingMembers: List<MemberModel>.from((json["waitingMembers"] as List).map(
            (e) => MemberModel.id(id: e.toString()),
          )),
          capacity: json["capacity"],
        );
        model._id = json["_id"];
        //model._createdAt = DateTime.parse(json['createdAt']).toLocal();
        return model;
      } else {
        debugPrint("SessionModel fromJson: $err");
        rethrow;
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'dateTimeStart': dateTimeStart,
      'dateTimeEnd': dateTimeEnd,
      'capacity': capacity,
      'mainMembers': mainMembers.map((e) => e.id).toList(),
      'waitingMembers': waitingMembers.map((e) => e.id).toList(),
    };
  }
}

/*
import 'package:flutter/material.dart';
import 'package:silivri_havuz/model/trainer_model.dart';
import 'package:silivri_havuz/utils/enums.dart';

import '../network/api.dart';
import '../utils/extension.dart';
import 'member_model.dart';

class SessionModel implements JsonProtocol {
  SessionModel({
    required this.sportType,
    required this.trainer,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.capacity,
    required this.mainMembers,
    required this.waitingMembers,
  });

  late DateTime _createdAt;
  DateTime get createdAt => _createdAt;

  late String _id;
  String get id => _id;

  final SportTypes sportType;
  final TrainerModel trainer;
  final DateTime dateTimeStart, dateTimeEnd;
  String get date => dateFormat.format(dateTimeStart);
  String get timeStart => timeFormat.format(dateTimeStart);
  String get timeEnd => timeFormat.format(dateTimeEnd);

  final int capacity;
  List<MemberModel> mainMembers;
  List<MemberModel> waitingMembers;

  factory SessionModel.fromJson({required Map<String, dynamic> json}) {
    try {
      SessionModel model = SessionModel(
        sportType: SportTypes.fromString(json["sportType"]),
        trainer: TrainerModel.fromJson(json: json["trainer"]),
        dateTimeStart: DateTime.parse(json["dateTimeStart"]).toLocal(),
        dateTimeEnd: DateTime.parse(json["dateTimeEnd"]).toLocal(),
        mainMembers: json["mainMembers"],
        waitingMembers: json["waitingMembers"],
        capacity: json["capacity"],
      );
      model._id = json["_id"];
      model._createdAt = DateTime.parse(json['createdAt']).toLocal();
      return model;
    } catch (err) {
      if (err.toString() == "type 'List<dynamic>' is not a subtype of type 'List<MemberModel>'") {
        SessionModel model = SessionModel(
          sportType: SportTypes.fromString(json["sportType"]),
          trainer: TrainerModel.fromJson(json: json["trainer"]),
          dateTimeStart: DateTime.parse(json["dateTimeStart"]).toLocal(),
          dateTimeEnd: DateTime.parse(json["dateTimeEnd"]).toLocal(),
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'sportType': sportType.toString(),
      'trainer': trainer.id,
      'dateTimeStart': dateTimeStart.toIso8601String(),
      'dateTimeEnd': dateTimeEnd.toIso8601String(),
      'capacity': capacity,
      'mainMembers': mainMembers.map((e) => e.id).toList(),
      'waitingMembers': waitingMembers.map((e) => e.id).toList()
    };
  }
}

 */
