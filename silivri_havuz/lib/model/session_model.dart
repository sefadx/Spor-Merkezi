import 'package:intl/intl.dart';

import '../network/api.dart';
import '../utils/extension.dart';
import 'member_model.dart';

class SessionModel implements JsonProtocol {
  SessionModel({
    this.createdAt,
    required this.sessionName,
    required this.trainer,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.capacity,
    required this.mainMembers,
    required this.waitingMembers,
  });

  final DateTime? createdAt;
  final String sessionName, trainer;
  final DateTime dateTimeStart, dateTimeEnd;
  String get date => format.format(dateTimeStart);
  String get timeStart => "${dateTimeStart.hour}:${dateTimeStart.minute}";
  String get timeEnd => "${dateTimeEnd.hour}:${dateTimeEnd.minute}";

  final int capacity;
  final List<MemberModel> mainMembers;
  final List<MemberModel> waitingMembers;

  factory SessionModel.fromJson({required Map<String, dynamic> json}) {
    return SessionModel(
      createdAt: json['cratedAt'],
      sessionName: json["sessionName"],
      trainer: json["trainerName"],
      dateTimeStart: json["dateTimeStart"],
      dateTimeEnd: json["dateTimeEnd"],
      capacity: json["capacity"],
      mainMembers: json["mainMembers"],
      waitingMembers: json["waitingMembers"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionName': sessionName,
      'trainerName': trainer,
      'dateTimeStart': dateTimeStart.toIso8601String(),
      'dateTimeEnd': dateTimeEnd.toIso8601String(),
      'capacity': capacity,
      'mainMembers': mainMembers,
      'waitingMembers': waitingMembers
    };
  }
}
