import 'package:intl/intl.dart';

import '../network/api.dart';
import '../utils/extension.dart';
import 'member_model.dart';

class SessionModel implements JsonProtocol {
  SessionModel({
    required this.sessionName,
    required this.trainerName,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.capacity,
    required this.participants,
  });

  final String sessionName, trainerName;
  final DateTime dateTimeStart, dateTimeEnd;
  String get date => format.format(dateTimeStart);
  String get timeStart => "${dateTimeStart.hour}:${dateTimeStart.minute}";
  String get timeEnd => "${dateTimeEnd.hour}:${dateTimeEnd.minute}";

  final int capacity;
  final List<MemberModel> participants;

  factory SessionModel.fromJson({required Map<String, dynamic> json}) {
    return SessionModel(
        sessionName: json["sessionName"],
        trainerName: json["trainerName"],
        dateTimeStart: json["dateTimeStart"],
        dateTimeEnd: json["dateTimeEnd"],
        capacity: json["capacity"],
        participants: json["participants"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionName': sessionName,
      'trainerName': trainerName,
      'dateTimeStart': dateTimeStart.toIso8601String(),
      'dateTimeEnd': dateTimeEnd.toIso8601String(),
      'capacity': capacity,
      'participants': participants,
    };
  }
}
